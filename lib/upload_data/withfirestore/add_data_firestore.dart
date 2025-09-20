import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDataFirestore extends StatefulWidget {
  const AddDataFirestore({super.key});

  @override
  State<AddDataFirestore> createState() => _AddDataFirestoreState();
}

class _AddDataFirestoreState extends State<AddDataFirestore> {
  final firestore = FirebaseFirestore.instance.collection('Users');
  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final rolecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Add User in Firestore",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Name
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Age
                TextFormField(
                  controller: agecontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: const Icon(Icons.cake),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Role
                TextFormField(
                  controller: rolecontroller,
                  decoration: InputDecoration(
                    labelText: "Designation",
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      String id = DateTime.now().millisecondsSinceEpoch.toString();

                      firestore.doc (id).set({
                        'ID': id,
                        'Name': namecontroller.text.trim(),
                        'Age': agecontroller.text.trim(),
                        'Role': rolecontroller.text.trim(),
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Data uploaded successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        namecontroller.clear();
                        agecontroller.clear();
                        rolecontroller.clear();
                      }).onError((error, stack) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("❌ $error"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text(
                      "Add Data",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
