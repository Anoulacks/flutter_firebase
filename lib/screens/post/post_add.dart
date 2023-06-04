import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_tp/blocs/posts_bloc/posts_bloc.dart';

class PostAdd extends StatefulWidget {
  const PostAdd({Key? key}) : super(key: key);

  static const String routeName = '/PostAdd';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajout d\'un Post'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champs Obligatoire';
                }
                return null;
              },
              controller: titleController,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champs Obligatoire';
                }
                return null;
              },
              controller: descriptionController,
            ),
            BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {
                if (state.status == PostsStatus.success) {
                  Navigator.of(context).pop();
                } else if (state.status == PostsStatus.error) {
                  _showSnackBar(context, state.error ?? '');
                }
              },
              builder: (context, state) {
                return Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onAddPost(
                          context,
                          titleController.text,
                          descriptionController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post Crée')),
                        );
                      }
                    },
                    child: const Text('Créer'),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void _onAddPost(BuildContext context, title, description) {
    BlocProvider.of<PostsBloc>(context).add(AddPost(title, description));
  }
}
