import 'package:flutter/material.dart';

class Login extends StatelessWidget{
  const Login({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Robot Demo")

      ),
      body: const center(
        child: Text(
          "Login Page"
        )
      )
    )
  }

}