import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_tp/blocs/posts_bloc/posts_bloc.dart';
import 'package:flutter_firebase_tp/models/post.dart';
import 'package:flutter_firebase_tp/screens/post/post_list.dart';

class PostDetail extends StatefulWidget {
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
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    super.initState();
  }

  bool checkUpdate = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: widget.post.title);
    final descriptionController =
        TextEditingController(text: widget.post.description);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                enabled: checkUpdate,
                // initialValue: widget.user.phoneNumber,
                decoration: const InputDecoration(
                  labelText: "Titre",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champs Obligatoire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                enabled: checkUpdate,
                //initialValue: widget.user.job,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              checkUpdate
                  ? TextButton(
                      onPressed: () => {
                        if (formKey.currentState!.validate())
                          {
                            //UserServices.updateUser(widget.user.id,typeUser, jobController.text, numberController.text, addressController.text)
                          }
                      },
                      child: BlocConsumer<PostsBloc, PostsState>(
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
                              PostList.navigateTo(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Post Modifié')),
                              );
                              break;
                          }
                        },
                        builder: (context, state) {
                          return Builder(builder: (context) {
                            return Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final Post updatePost = Post(
                                        id: widget.post.id,
                                        title: titleController.text,
                                        description:
                                            descriptionController.text);
                                    _onUpdatePost(context, updatePost);
                                  }
                                },
                                child: const Text('Modifier le post'),
                              ),
                            );
                          });
                        },
                      ),
                    )
                  : const Text("")
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_enableUpdate()},
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _enableUpdate() {
    setState(() {
      checkUpdate = !checkUpdate;
    });
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void _onUpdatePost(BuildContext context, Post post) {
    BlocProvider.of<PostsBloc>(context).add(UpdatePost(post));
  }
}
