import 'package:firebase/models/artist_model.dart';
import 'package:firebase/services/cloud_firestore_service.dart';
import 'package:flutter/material.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final CloudFirestoreService _cloudFirestoreService = CloudFirestoreService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _albumsController = TextEditingController();

  void insertArtist() {
    _cloudFirestoreService.insertArtist('artistas', {
      'nombre': _nombreController.text,
      'genero': _generoController.text,
      'albums': int.parse(_albumsController.text),
      'inicio': int.parse(_inicioController.text),
    });
    _nombreController.clear();
    _generoController.clear();
    _albumsController.clear();
    _inicioController.clear();
  }

  void deleteArtist(String docId) {
    _cloudFirestoreService.deleteArtist('artistas', docId);
  }

  void updateArtist(
      String docId,
      TextEditingController nombreController,
      TextEditingController generoController,
      TextEditingController albumsController,
      TextEditingController inicioController) {
    _cloudFirestoreService.updateArtist('artistas', docId, {
      'nombre': nombreController.text,
      'genero': generoController.text,
      'albums': int.parse(albumsController.text),
      'inicio': int.parse(inicioController.text),
    });
    nombreController.clear();
    generoController.clear();
    albumsController.clear();
    inicioController.clear();
  }

  void showDialogEdit(ArtistModel artist) {
    TextEditingController nombreController = TextEditingController();
    TextEditingController generoController = TextEditingController();
    TextEditingController albumsController = TextEditingController();
    TextEditingController inicioController = TextEditingController();
    // Recuperar los datos del objeto artist a los controladores
    nombreController.text = artist.name;
    generoController.text = artist.genre;
    albumsController.text = artist.albums.toString();
    inicioController.text = artist.start.toString();
    // Mostrar el dialogo
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Editar artista'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: generoController,
                  decoration: const InputDecoration(labelText: 'Género'),
                ),
                TextField(
                  controller: albumsController,
                  decoration: const InputDecoration(labelText: 'Álbums'),
                ),
                TextField(
                  controller: inicioController,
                  decoration: const InputDecoration(labelText: 'Inicio'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  updateArtist(artist.id, nombreController, generoController,
                      albumsController, inicioController);
                  Navigator.pop(context);
                },
                child: const Text('Actualizar'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis artistas de Spotify'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: _generoController,
            decoration: const InputDecoration(labelText: 'Género'),
          ),
          TextField(
            controller: _albumsController,
            decoration: const InputDecoration(labelText: 'Álbums'),
          ),
          TextField(
            controller: _inicioController,
            decoration: const InputDecoration(labelText: 'Inicio'),
          ),
          ElevatedButton(
            onPressed: insertArtist,
            child: const Text('Agregar artista'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _cloudFirestoreService.getArtists('artistas'),
              builder: (context, AsyncSnapshot<List<ArtistModel>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView(
                  children: snapshot.data!.map((ArtistModel artist) {
                    return ListTile(
                      title: Text(artist.name),
                      subtitle: Text('Genero: ${artist.genre}'),
                      onTap: () => showDialogEdit(artist),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteArtist(artist.id),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
