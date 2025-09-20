import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  File? pickedImage;


  showDialogBox(){

    return showDialog(context: context, builder: (BuildContext context){

      return AlertDialog(
        title:  Text("Pick Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
            ),
            ListTile(
              onTap: (){
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              leading: Icon(Icons.image),
              title: Text("Gallery"),
            ),



          ],
        ),
      );

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Sign Up Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              InkWell(
                onTap: (){
                  showDialogBox();},
                child: pickedImage !=null ? CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(pickedImage!),

                ) : CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 60,
                  child: Icon(Icons.person, size: 80,),

                ),
              ),

              const SizedBox(height: 24),
              TextField(
                cursorColor: Colors.blueGrey,
                controller: emailController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  prefixIcon: Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
              const SizedBox(height: 24),


              TextField(
                cursorColor: Colors.blueGrey,
                controller: passwordcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.password),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              
              ElevatedButton(onPressed: (){}, child: Text("Upload data"))

            ],
          ),
        ),
      ),
    );
  }



  pickImage(ImageSource imagesource ) async{
    try{

      final photo = await ImagePicker().pickImage(source: imagesource);
      if(photo == null) return;

      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

    }catch(e){
      log(e.toString());
    }

  }


}
