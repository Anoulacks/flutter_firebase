import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_tp/data_sources/posts_data_source.dart';
import 'package:flutter_firebase_tp/models/post.dart';

class PostsRepository {
  final PostsDataSource remoteDataSource;

  PostsRepository({
    required this.remoteDataSource,
  });

  Future<List<Post>> getPosts() async {
    try {
      final products = await remoteDataSource.getPosts();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPosts(title, description) async {
    try {
      await remoteDataSource.addPosts(title, description);
    } catch (e) {
      rethrow;
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getInstancePosts(title, description) async {
    return FirebaseFirestore.instance.collection('posts').snapshots();
  }
}
