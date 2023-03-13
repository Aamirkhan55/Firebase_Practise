import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/utiles/flutter_tost.dart';
import 'package:log_in/widgets/components.dart';

class FirestorePost extends StatefulWidget {
  const FirestorePost({super.key});

  @override
  State<FirestorePost> createState() => _FirestorePostState();
}

class _FirestorePostState extends State<FirestorePost> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore'),
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

                fireStore.doc(id).set({
                  'title' : postController.text.toString(),
                  'id' : id,
                })
                .then((value) {
                  Utils().toastMessage('Value Added');
                })
                .onError((e, stackTrace) {
                  Utils().toastMessage(e.toString());
                });
              }),
        ],
      ),
    );
  }
}
