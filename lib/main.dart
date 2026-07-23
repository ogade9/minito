import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/sign_in.dart';
import 'pages/login.dart';
import 'pages/connection.dart';
import 'signaling_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Robo',
      initialRoute: '/',
      routes: {
        '/': (context) => Connections(),
        '/signin':(context) => SignIn(),
        '/login':(context) => Login(),
        '/connection':(context) => Connection(),
      },
    );
  }
  
}
