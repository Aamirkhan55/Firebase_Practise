import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utiles/flutter_tost.dart';
import 'package:log_in/widgets/components.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          TextFormField(
            maxLines: 4,
            controller: postController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter Your Post',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().microsecondsSinceEpoch.toString();

                databaseRef.child(id).set({
                  'id': id,
                  'title': postController.text.toString(),
                }).then(
                  (value) {
                    Utils().toastMessage('Post Added');
                    setState(() {
                      loading = false;
                    });
                  },
                ).onError((e, stackTrace) {
                  Utils().toastMessage(e.toString());
                  setState(() {
                    loading = false;
                  });
                });
              }),
        ],
      ),
    );
  }
}
