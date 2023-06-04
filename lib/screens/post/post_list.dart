import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_tp/blocs/posts_bloc/posts_bloc.dart';
import 'package:flutter_firebase_tp/models/post.dart';
import 'package:flutter_firebase_tp/repository/posts_repository.dart';
import 'package:flutter_firebase_tp/screens/post/post_add.dart';
import 'package:flutter_firebase_tp/screens/post/post_detail.dart';
import 'package:flutter_firebase_tp/screens/post/widgets/post_item.dart';

class PostList extends StatefulWidget {
  static const String routeName = '/PostList';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const PostList({super.key});


  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  void _crash() async {
    try {
      throw Exception("Nouveau bug !");
      ;
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Liste des posts'),
              ),
              body: BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PostsStatus.initial:
                      return const SizedBox();
                    case PostsStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case PostsStatus.error:
                      return Center(
                        child: Text(state.error),
                      );
                    case PostsStatus.success:
                      final posts = state.posts;

                      if (posts.isEmpty) {
                        return const Center(
                          child: Text('Aucun produit'),
                        );
                      }

                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostItem(
                            post: post,
                            onTap: () => _onPostTap(context, post),
                          );
                        },
                      );
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => { PostAdd.navigateTo(context) },
                child: const Icon(Icons.add),
              ),
            );
          }
    );
  }

  void _onPostTap(BuildContext context, Post post) {
    PostDetail.navigateTo(context, post);
  }
}