import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/ui/firestore/add_firestore.dart';
import 'package:log_in/utiles/flutter_tost.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final postFilter = TextEditingController();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Firestore Screen'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
              },
              icon: const Icon(Icons.power_settings_new_sharp)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            controller: postFilter,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: fireStore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.teal,
                        strokeWidth: 3,
                      );
                    }

                    if (snapshot.hasError) {
                      Utils().toastMessage('Some Error Occured');
                    }

                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(snapshot.data!.docs[index].toString()),
                                subtitle: Text(snapshot.data!.docs[index]['id']
                                    .toString()),
                                trailing: PopupMenuButton(
                                    child: const Icon(
                                      Icons.more_vert_outlined,
                                    ),
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                ref
                                                    .doc(snapshot
                                                        .data!.docs[index]
                                                        .toString())
                                                    .update({
                                                  'title': editController.text
                                                      .toString(),
                                                }).then((value) {
                                                  Utils().toastMessage(
                                                      'Updated Successfully');
                                                }).onError((e, stackTrace) {
                                                  Utils().toastMessage(
                                                      e.toString());
                                                });
                                              },
                                              title: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.red),
                                              ),
                                              leading: const Icon(
                                                Icons.edit,
                                                size: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  ref
                                                      .doc(snapshot.data!
                                                          .docs[index]['id']
                                                          .toString())
                                                      .delete();
                                                },
                                                title: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                leading: const Icon(
                                                  Icons.delete,
                                                  size: 10,
                                                  color: Colors.red,
                                                ),
                                              )),
                                        ]),
                              );
                            }));
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FirestorePost()));
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }

  Future<void> fireStoreDailog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: const TextField(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancle'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
