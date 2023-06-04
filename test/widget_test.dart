// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_tp/blocs/posts_bloc/posts_bloc.dart';
import 'package:flutter_firebase_tp/data_sources/posts_data_source.dart';
import 'package:flutter_firebase_tp/models/post.dart';
import 'package:flutter_firebase_tp/repository/posts_repository.dart';
import 'package:flutter_firebase_tp/screens/post/post_list.dart';
import 'package:flutter_test/flutter_test.dart';

class EmptyRemoteDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 3));
    return [];
  }
}

class FailingRemoteDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 3));
    throw Exception('Error');
  }
}

void main() {
  testWidgets('Posts Screen with success', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          remoteDataSource: EmptyRemoteDataSource(),
        ),
        child: BlocProvider(
          create: (context) => PostsBloc(
            repository: RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: PostList(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Posts'), findsOneWidget);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Aucun post'), findsOneWidget);
  });

  testWidgets('Posts Screen with error', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          remoteDataSource: FailingRemoteDataSource(),
        ),
        child: BlocProvider(
          create: (context) => PostsBloc(
            repository: RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: PostList(),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Liste des posts'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text(Exception('Nouveau bug !').toString()), findsOneWidget);
  });
}
