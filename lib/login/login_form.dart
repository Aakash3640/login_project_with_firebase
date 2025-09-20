import 'package:firebase/login/forget_password.dart';
import 'package:firebase/login/homescreen.dart';
import 'package:firebase/login/signing_form.dart';
import 'package:firebase/login/user_profile_screen.dart';
import 'package:firebase/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../phoneauth/phone_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  login() {

    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
        )
        .then((value) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Logged In")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
      emailController.clear();
      passwordController.clear();

    })
        .onError((error, stack) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unsuccessful ${error.toString()}")));

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Form",
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
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 25),
          
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
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
          
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPassword()));
                    }, child: Text("Forgot Password?",style: TextStyle(color: Colors.blue),)),
                  ),
          
          
          
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          login();
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
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigningForm(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          
                  
                  OutlinedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PhoneAuth()));
                      },
          
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey
                      ),
                      child: Text("Login with Phone", style: TextStyle(color: Colors.white),)),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
