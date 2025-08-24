import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_application_1/widgets/settings_background.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return SettingsUIBackground(
      child:Column(
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
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              Navigator.of(context).pushNamed(verifyEmailRoute);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                devtools.log('Weak Password');
              } else if (e.code == 'email-already-in-use') {
              devtools.log('Email is already in use');              
              } else if (e.code == 'invalid-email') {
                devtools.log('Invalid email entered');
              }
            }
          },
          child: const Text(
            'Register',
               style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),           
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: Text(
              'Already have an account? Login here',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),              
              ),)
        ],
      ),
    );
  }
  }