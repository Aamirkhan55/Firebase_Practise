import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:log_in/ui/post/add_post.dart';
import 'package:log_in/utiles/flutter_tost.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final postFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Post Screen'),
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
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: ((context, AsyncSnapshot<DatabaseEvent>snapshot) {
          //       if (!snapshot.hasData) {
          //         return const CircularProgressIndicator(
          //           color: Colors.blueAccent,
          //           strokeWidth: 2,
          //         );
          //       } else {
          //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();

          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['title']),
          //             );
          //           }
          //            );
          //       }
          //     })
          //     )
          // ),
          //Method Two Using FirebaseAnimatedList
          Expanded(
            child: FirebaseAnimatedList(
              query : ref,
              itemBuilder :(context, snapshot, animation, index) {
                
                final title = snapshot.child('title').value.toString();

                if (postFilter.text.isEmpty) {
                   return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
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
                              showMyDailog(
                                title, 
                                snapshot.child('id').value.toString());
                            },
                            title: const Text(
                              'Edit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red
                              ),
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
                               ref.child(snapshot.child('id').value.toString());
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
                          )
                          ),
                      ]),
                );
                } else if (title.toLowerCase().contains(postFilter.text.toLowerCase())) {
                   return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                );
                }else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(Icons.note_add),
        ),
    );
  }
   Future<void> showMyDailog(String title, String id) async{
    editController.text = title;
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return  AlertDialog(
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
                ref.child(id).update(
                  {
                    'title' : editController.text.toString(),
                  }
                ).then((value) {
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }, 
              child: const Text('Update')
              ),
          ],
        );
      }
      );
  }
}
