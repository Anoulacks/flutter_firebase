import 'package:flutter/material.dart';
import 'package:flutter_firebase_tp/models/post.dart';

class PostDetail extends StatelessWidget {
  static const String routeName = '/PostDetail';

  static void navigateTo(BuildContext context, Post post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  final Post post;

  const PostDetail({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title),
            Text(post.description),
          ],
        ),
      ),
    );
  }
}
