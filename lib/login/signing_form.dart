import 'dart:io';
import 'dart:math';

import 'package:firebase/login/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';



class SigningForm extends StatefulWidget {
  const SigningForm({super.key});

  @override
  State<SigningForm> createState() => _SigningFormState();
}

class _SigningFormState extends State<SigningForm> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;

  File? _image;
 final picker = ImagePicker();
 final storage = FirebaseStorage.instance;
  final databaseref = FirebaseDatabase.instance.ref("Users");


 Future imagefromGallery() async {
   final pickedfile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
   setState(() {
     if(pickedfile != null){
       _image = File(pickedfile.path);
     }else{
       debugPrint("No image selected");
     }
   });
 }


  Future<String?> uploadImageAndSave(String uid) async {
    if (_image == null) return null;
    setState(() {
      loading = true;
    });
    try {
      final ref = FirebaseStorage.instance.ref(
        'images/user_profile_image/$uid.jpg', // use unique ID, not name
      );

      await ref.putFile(_image!.absolute);

      // get image URL
      final url = await ref.getDownloadURL();

      // save url in realtime db under user
      await databaseref.child(uid).update({
        'ImagePath': url,
      });


      debugPrint("Image uploaded and URL saved!");
      setState(() {
        _image = null; // clear after upload

      });

      return url;
    } catch (error) {

      debugPrint("Image upload failed: $error");

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> signUp() async {
    setState(() {
      loading = true;
    });

    auth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) async {


      final user = FirebaseAuth.instance.currentUser!;
      String uid = user.uid;
      // upload image only if signup succeeded
      String? imageurl = await uploadImageAndSave(uid);


        await databaseref.child(uid).set({
          'ID': uid,
          'Name': nameController.text.trim(),
          'Email': emailController.text.trim(),
          'ImagePath': imageurl ?? '',
          'Age': '',
          'Designation': '',

        });


      // now show success once
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully account created!")),
      );

      Navigator.pop(context);
    })
        .onError((error, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unsuccessful: ${error.toString()}")),
      );
      setState(() {
        loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SignUp Form",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
          
                  SizedBox(height: 25),
          
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                     backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        ) // Placeholder icon if no image is picked
                            : null,
                      ),
          
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: (){
                              imagefromGallery();
          
                            },
                            child: CircleAvatar(
                              radius: 20, // Size of the edit icon background
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          
                  SizedBox(height: 25),

                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter Name",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Name";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter Email",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Email";
                      } else if (!value.contains("@")) {
                        return "Not valid Email";
                      }
                      return null;
                    },
                  ),
          
                  SizedBox(height: 20),
          
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Enter Password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password";
                      }else if(value.length < 6){
                        return "Password too short";
                      }
                      return null;
                    },
                  ),
          
                  SizedBox(height: 25),
          
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {

                         signUp();
          
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: loading ? CircularProgressIndicator(color: Colors.white,) : Text(
                        "Create",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                  ),
          
          
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
