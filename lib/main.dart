import 'package:flutter/material.dart';
import 'package:log_in/ui/splash_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
    title: 'Flutter App',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: const SplashScreen(),
  ));
}

