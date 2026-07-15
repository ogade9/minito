import 'package:flutter/material.dart';
import 'pages/sign_in.dart';
import 'pages/login.dart';

void main() {
  runApp(const RobotOpsApp());
}

class RobotOpsApp extends StatelessWidget {
  const RobotOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot OPS',
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}