import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistModel {
  final String id;
  final String name;
  final String genre;
  final int albums;
  final int start;

  ArtistModel({
    required this.id,
    required this.name,
    required this.genre,
    required this.albums,
    required this.start,
  });

  // convertir un artist a un map
  // insertar un artista en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'genero': genre,
      'albums': albums,
      'inicio': start,
    };
  }

  factory ArtistModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ArtistModel(
      id: doc.id,
      name: doc['nombre'],
      genre: doc['genero'],
      albums: doc['albums'] as int,
      start: doc['inicio'] as int,
    );
  }
}
