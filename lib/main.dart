import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_tp/blocs/posts_bloc/posts_bloc.dart';
import 'package:flutter_firebase_tp/data_sources/posts_data_source.dart';
import 'package:flutter_firebase_tp/repository/posts_repository.dart';
import 'package:flutter_firebase_tp/screens/post/post_add.dart';
import 'package:flutter_firebase_tp/screens/post/post_detail.dart';
import 'package:flutter_firebase_tp/screens/post/post_list.dart';

import 'models/post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    runApp(const MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(remoteDataSource: PostsDataSource()),
      child: BlocProvider(
        create: (context) => PostsBloc(
          repository: RepositoryProvider.of<PostsRepository>(context),
        )..add(GetAllPosts()),
        child: MaterialApp(
          title: 'TP Flutter Firebase',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (context) => const PostList(),
            PostList.routeName: (context) => const PostList(),
            PostAdd.routeName: (context) => const PostAdd(),
          },
          onGenerateRoute: (settings) {
            Widget content = const SizedBox.shrink();

            switch (settings.name) {
              case PostDetail.routeName:
                final arguments = settings.arguments;
                if (arguments is Post) {
                  content = PostDetail(post: arguments);
                }
                break;
            }

            return MaterialPageRoute(
              builder: (context) {
                return content;
              },
            );
          },
        ),
      ),
    );
  }
}
