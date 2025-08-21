
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/register_view.dart';

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
    return Column(
      children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your email here'
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Enter your password here',
          ),  
        ),
        Row(
          children: [
            TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =  FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: email,
                  password: password);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  print('User not found');
                } else {
                    print(e);
                }              
              } 
            },
            child: const Text('Login'),
            ),
            TextButton(onPressed: () async {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterView())); 
            },
             child: const Text('New user? Register here'))
          ],
        ),
      ],
    );
}
}