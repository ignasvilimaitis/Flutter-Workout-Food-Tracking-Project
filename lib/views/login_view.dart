import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_application_1/widgets/settings_background.dart';

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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(
          8.0,
          24.0,
          8.0,
          15.0
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((16.0)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/great_logo.png"),
              size: 200.0,
              ),
            SizedBox(height: 100.0),
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
              padding: EdgeInsets.all(8.0)),
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
            TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =  await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: email,
                  password: password
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/settings/',
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
                '/settings/',
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
      
      ),
      backgroundColor: Colors.grey,      
    );
   
}
}