import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_tp/models/post.dart';

class PostsDataSource {
  Future<List<Post>> getPosts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('posts').get();
    final postsData = snapshot.docs.map((element) => Post.fromSnapshot(element)).toList();
    return postsData;
  }

  Stream<QuerySnapshot> getPostsRealTime() {
    final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

    final Stream<QuerySnapshot> postStream = postsCollection.snapshots(includeMetadataChanges: true);
    return postStream;
  }

  Future<void> addPosts(title, description) async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('posts');

    try {
      await postsCollection.add({"title": title, "description": description});
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  Future<void> updatePosts(Post post) async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('posts');

    try {
      await postsCollection
          .doc(post.id)
          .update({'title': post.title, 'description': post.description});
    } catch (error) {
      print("Failed to update user: $error");
    }
  }
}
