import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_tp/models/post.dart';

class PostsDataSource {
  Future<List<Post>> getPosts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('Posts').get();
    final postsData = snapshot.docs.map((e) => Post.fromSnapshot(e)).toList();
    return postsData;
  }

  Future<void> addPosts(title, description) async {
    final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

    try {
      await postsCollection.add({"title": title, "description": description});
      print("User added");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }
}