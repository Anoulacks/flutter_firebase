import 'package:bloc/bloc.dart';
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
      await Future.delayed(const Duration(seconds: 1));
      try {
        final postsData = await repository.getPosts();

        emit(state.copyWith(status: PostsStatus.success, posts: postsData));
      } catch (error) {
        emit(
            state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<AddPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));
      await Future.delayed(const Duration(seconds: 3));

      try {
        await repository.addPosts(event.title, event.description);
        emit(state.copyWith(status: PostsStatus.success));
      } catch (error) {
        emit(
            state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<UpdatePost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));
      await Future.delayed(const Duration(seconds: 3));

      try {
        await repository.updatePosts(event.post);
        emit(state.copyWith(status: PostsStatus.success));
      } catch (error) {
        emit(
            state.copyWith(status: PostsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });
  }
}
