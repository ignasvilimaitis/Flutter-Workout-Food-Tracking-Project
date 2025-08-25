import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_application_1/widgets/ui_background.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
    return UIBackground(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 50.0),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(
                  maxWidth: 375.0
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0)),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(
                  maxWidth: 375.0
                ),                
              ),
            ),
            Padding(padding: EdgeInsets.all(12.0)),
            TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: email,
                  password: password
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    settingsRoute,
                     (route) => false,
                  );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  devtools.log('Invalid credential');
                } else {
                  devtools.log(e.toString());
                }              
              } 
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
              ),
            ),
            TextButton(onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loggingFoodRoute,
                (route) => false,
              );
            },
             child: const Text(
              'New user? Register here',
               style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
              ),
            )
          ],
        ),
    );      
  }
}