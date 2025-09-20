
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref("Users");

  @override
  Widget build(BuildContext context) {
    final String? uid = auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.blueGrey,
      ),
      body: uid == null
          ? const Center(child: Text("No user logged in"))
          : StreamBuilder<DatabaseEvent>(
        stream: dbRef.child(uid).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("Profile not found"));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final name = data["Name"] ?? "";
          final age = data["Age"] ?? "";
          final role = data["Designation"] ?? "";
          final profileUrl = data["ImagePath"] ?? "";

          return ListTile(
            leading: profileUrl.isNotEmpty
                ? CircleAvatar(backgroundImage: NetworkImage(profileUrl))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(name),
            subtitle: Text("Age: $age\nRole: $role"),
          );
        },
      ),
    );
  }
}
