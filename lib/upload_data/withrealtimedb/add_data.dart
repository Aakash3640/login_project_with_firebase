import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateData extends StatefulWidget {
  final String userID;
  const UpdateData({super.key, required this.userID});


  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {



  final databaseref = FirebaseDatabase.instance.ref("Users");
  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final rolecontroller = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();

  }


  Future<void> fetchUserData() async{

    try{
      final snapshot = await databaseref.child(widget.userID).get();
      if (snapshot.exists) {
      final data = snapshot.value as Map;

      setState(() {

        namecontroller.text = data['Name'] ?? '';
        agecontroller.text = data['Age'] ?? '';
        rolecontroller.text = data['Designation'] ?? '';

      });

      }

    }catch(e){
      debugPrint("Error fetching data: $e");

    }

  }




  Future<void> updateUserData() async{
    setState(() {
      loading = true;
    });

    try{

      await databaseref.child(widget.userID).update({

        'Name': namecontroller.text.trim(),
        'Age': agecontroller.text.trim(),
        'Designation': rolecontroller.text.trim(),

      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Data updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $e"), backgroundColor: Colors.red),
      );
      debugPrint("Error Updating data: $e");
    } finally{

      setState(() {
        loading = false;

      });

      Navigator.pop(context);
    }

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Update User",
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


                const SizedBox(height: 16),

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
                  child: ElevatedButton(
                    onPressed: loading ? null : updateUserData ,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                    child: loading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Update Data",
                      style: TextStyle(fontSize: 16),
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
