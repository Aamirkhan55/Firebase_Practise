import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/ui/UploadImage/image_scraeen.dart';
import 'package:log_in/ui/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      // Used PostScreen For Real Time Datebase
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const PostScreen()));

      // Used Firestore For Cloud Database
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UploadScreen()));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
