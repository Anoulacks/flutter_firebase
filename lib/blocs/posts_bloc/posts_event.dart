part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class GetAllPosts extends PostsEvent {
  GetAllPosts();
}

class AddPost extends PostsEvent {
  final String title;
  final String description;

  AddPost(this.title, this.description);
}

class UpdatePost extends PostsEvent {
  final Post post;

  UpdatePost(this.post);
}
