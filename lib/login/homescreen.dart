import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/upload_data/withfirestore/add_data_firestore.dart';
import 'package:firebase/login/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../upload_data/withrealtimedb/add_data.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final auth = FirebaseAuth.instance;
  final searchfilter = TextEditingController();
  final editController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('Users');
  // final firestore = FirebaseFirestore.instance.collection('Users').snapshots();
  // final firestoreRef = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginForm()),
                );
              });
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: TextFormField(
              controller: searchfilter,
              decoration: InputDecoration(
                hintText: "search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                final name = snapshot.child('Name').value.toString();

                if (searchfilter.text.isEmpty) {
                  return Card(
                    color: Colors.white70,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: snapshot.child('ImagePath').value != null
                              ? NetworkImage(snapshot.child('ImagePath').value.toString())
                              : null,
                          child: snapshot.child('ImagePath').value == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      title: Text(
                        "${snapshot.child('Name').value.toString()}    ${snapshot.child('Age').value.toString()}",
                      ),
                      subtitle: Text(snapshot.child('Designation').value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateData(userID: snapshot.child('ID').value.toString(),)));
                            },
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () async {
                              ref
                                  .child(snapshot.child('ID').value.toString())
                                  .remove();

                                final imagpath = FirebaseStorage.instance.refFromURL(snapshot.child('ImagePath').value.toString());
                                await imagpath.delete();
                            },
                            value: 2,
                            child: ListTile(
                              leading: Icon(Icons.delete_forever),
                              title: Text("Delete"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (name.toLowerCase().contains(
                  searchfilter.text.toLowerCase(),
                )) {
                  return Card(
                    color: Colors.white70,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: snapshot.child('ImagePath').value != null
                            ? NetworkImage(snapshot.child('ImagePath').value.toString())
                            : null,
                        child: snapshot.child('ImagePath').value == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        "${snapshot.child('Name').value.toString()}    ${snapshot.child('Age').value.toString()}",
                      ),
                      subtitle: Text(snapshot.child('Designation').value.toString()),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),

        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blueGrey,
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (_) => AddData()));
      //   },
      //   child: Icon(Icons.add),
      // ),




    );
  }

  // Future<void> showMyDialogBox(String name, String id) async {
  //   editController.text = name;
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Update"),
  //         content: Container(
  //           child: TextField(
  //             controller: editController,
  //             decoration: InputDecoration(
  //               hintText: "Edit",
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               ref
  //                   .child(id)
  //                   .update({'Name': editController.text.toString()})
  //                   .then((value) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text(" Data updated successfully"),
  //                         backgroundColor: Colors.green,
  //                       ),
  //                     );
  //                     Navigator.pop(context);
  //                   })
  //                   .onError((error, stack) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text(" $error"),
  //                         backgroundColor: Colors.green,
  //                       ),
  //                     );
  //                   });
  //             },
  //             child: Text("Update"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text("Cancel"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<String?> getProileImage(String email) async {
    try {
      final ref = FirebaseStorage.instance.ref(
        'images/user_profile_image/$email',
      );
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error fetching image: $e");
      return null;
    }
  }
}

