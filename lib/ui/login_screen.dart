import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_in/ui/post/post_screen.dart';
import 'package:log_in/ui/signup_screen.dart';
import 'package:log_in/widgets/components.dart';

import '../utiles/flutter_tost.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fromKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logIn() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
      email: _email.text.toString(),
      password: _password.text.toString(),
    ).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
          setState(() {
            loading = false;
          });
    }).onError((e, stackTrace) {
      Utils().toastMessage(e.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _fromKey,
              child: Column(children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    helperText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      size: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.password,
                      size: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    title: 'LOGIN',
                    loading: loading,
                    onTap: () {
                      if (_fromKey.currentState!.validate()) {
                        logIn();
                      }
                    }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text('Sign Up'),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
