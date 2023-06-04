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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champs Obligatoire';
                  }
                  return null;
                },
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Titre",
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champs Obligatoire';
                  }
                  return null;
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              BlocConsumer<PostsBloc, PostsState>(
                listener: (context, state) {
                  switch (state.status) {
                    case PostsStatus.initial:
                      break;
                    case PostsStatus.loading:
                      _showSnackBar(context, 'Chargement');
                      break;
                    case PostsStatus.error:
                      _showSnackBar(context, state.error ?? '');
                      break;
                    case PostsStatus.success:
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post Crée')),
                      );
                      break;
                  }
                },
                builder: (context, state) {
                  return Builder(builder: (context) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onAddPost(
                              context,
                              titleController.text,
                              descriptionController.text,
                            );
                          }
                        },
                        child: const Text('Créer'),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
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
