import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/ui/login_screen.dart';
import 'package:log_in/utiles/flutter_tost.dart';
import 'package:log_in/widgets/components.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fromKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
      email: _email.text.toString(),
      password: _password.text.toString(),
    )
        .then((value) {
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
    return SafeArea(
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
                  title: 'SignUp',
                  loading: loading,
                  onTap: () {
                    if (_fromKey.currentState!.validate()) {
                      signUp();
                    }
                  }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Login'),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
