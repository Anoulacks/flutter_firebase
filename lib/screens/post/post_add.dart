import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_tp/models/post.dart';

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

  Future<void> _addPosts(title, description) async {
    final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

    try {
      await postsCollection.add({"title": title, "description": description});
      print("User added");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addPosts(titleController.text, descriptionController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
