import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Post.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return Post(
        id: document.id,
        title: data["title"],
        description: data["description"]
    );
  }
}