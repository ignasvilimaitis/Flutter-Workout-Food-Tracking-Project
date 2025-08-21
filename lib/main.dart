import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 124, 212, 7)),
      ),
      home: const HomePage(),
    ),
    );
  }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
              //final user = FirebaseAuth.instance.currentUser;
              //final emailVerified = user?.emailVerified ?? false;
              //if (emailVerified) {
              //  return const Text('Done');// Check if logged in maybe? If logged in go to login view
              //} else { // Here should be else if since they may not have even registered yet
              //  return const VerifyEmail();            
              //}
              return const LoginView();     
              default:
                return const Text('Loading...');
            }
            
          }
        ),
    );
  }
}