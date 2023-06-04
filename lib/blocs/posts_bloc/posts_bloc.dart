import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_tp/models/post.dart';
import 'package:flutter_firebase_tp/repository/posts_repository.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({required this.repository}) : super(PostsState()) {
    on<GetAllPosts>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        final _db = FirebaseFirestore.instance;
        final snapshot = await _db.collection('posts').get();
        final postsData = snapshot.docs.map((e) => Post.fromSnapshot(e)).toList();

        emit(state.copyWith(status: PostsStatus.success, posts: postsData));
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<AddPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        await repository.addPosts(event.title, event.description);
        emit(state.copyWith(status: PostsStatus.success));
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<UpdatePost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        await repository.updatePosts(event.post);
        emit(state.copyWith(status: PostsStatus.success));
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });
  }
}
