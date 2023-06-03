import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_tp/models/post.dart';
import 'package:flutter_firebase_tp/screens/post/post_add.dart';

class PostList extends StatefulWidget {
  const PostList({super.key, required this.title});

  final String title;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _crash() async {
    try {
      throw Exception("Nouveau bug !");;
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  Future<List<Post>> getPosts() async{
    final _db = FirebaseFirestore.instance;
    final snapshot = await _db.collection('posts').get();
    final postsData = snapshot.docs.map((e) => Post.fromSnapshot(e)).toList();
    for (Post post in postsData){
      print(post.description);
      print(post.title);
    }
    return postsData;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('liste des posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              PostAdd.navigateTo(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPosts,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}