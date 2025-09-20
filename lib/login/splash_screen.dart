import 'dart:async';

import 'package:firebase/login/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homescreen.dart';


class SplashScreen {

  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;


    if (user != null) {
      Timer(Duration(seconds: 3), () =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homescreen())));
    }
    else{
      Timer(Duration(seconds: 3), () =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginForm())));
    }
  }
}
