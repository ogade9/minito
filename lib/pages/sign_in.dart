import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';


class SignIn extends StatefulWidget{
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}
class _SignInState extends State<SignIn>{
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String userId = "";
  bool get hasUpperCase =>_passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasLowerCase =>_passwordController.text.contains(RegExp(r'[a-z]'));
  bool get hasNumber =>_passwordController.text.contains(RegExp(r'[0-9]'));
  bool get hasSpecialCharacter =>_passwordController.text.contains(RegExp(r'[@$!_]'));
  bool _isLoading = false;
  String _errorMessage ="";
  List<String> _errorMessages = [];
  //Ddebugging
  //Here
  Future<bool> _signin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _errorMessages = [];
    });
    if(_passwordController.text.length < 8){
      _errorMessages.add("Password is less than 8 characters");
    }
    if(hasUpperCase == false){
      _errorMessages.add("Password needs at least one UpperCase letter");
    }
    if(hasLowerCase == false){
      _errorMessages.add("Password needs at least one LowerCase letter");
    }
    if( hasNumber == false){
      _errorMessages.add("Password needs a numerical character");
    }
    if(hasSpecialCharacter == false){
      _errorMessages.add("Password needs to have at least one special character");
    }
    if(_errorMessages.isNotEmpty){
      return false;
      // if there are no errors that is if the password is valid, then firebase will
      // authenticate the use with the email and password
    }
    try {

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email: _emailController.text,
        password: _passwordController.text,
      );
      userId = credential.user!.uid;
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'weak-password'
            ? "The password provided is too weak"
            : e.code == 'email-already-in-use'
                ? "email exists"
                : "Something went wrong. Please try again.";
      });
    return false;
  } catch (e) {
    setState(() {
      _errorMessage = "Something went wrong. Please try again.";
    });
    return false;
  }
}
  //Sending Post request to express server
  Future<void> _sendRequest() async{
    final url = Uri.parse('http://localhost:5000/api/robot-users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId, 
        'fullName': _nameController.text.toString(),
        'email': _emailController.text.toString(),
        
      }),
    );
    print("UserId $userId");
    if(response.statusCode == 200 || response.statusCode == 201){
      print('New User added successfully');
      Navigator.pushNamed(context, '/login');

    }
    else{
      print('Unable to add a New User: ${response.statusCode}');
    }


  }
  Future<void> _handleCreateAccount() async{
    final success = await _signin();
    if (success){
      await _sendRequest();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFFE0E7FF),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    size: 42,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Join Minito to access robotic systems.",
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              const Text("Full Name"),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,

                decoration: InputDecoration(
                  hintText: "John Doe",
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Email"),

              const SizedBox(height: 8),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "john@email.com",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Password"),

              const SizedBox(height: 8),

              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms and Privacy Policy",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async{ 
                    await _handleCreateAccount();
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "Already have an account? Sign In",
                  ),
                ),
              ),

              const SizedBox(height: 30),
              if(_errorMessages.isNotEmpty)
                  for(int i=0; i < _errorMessages.length; i++)
                    Text(_errorMessages[i], style: TextStyle(color: Colors.blue)),
                    const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: TextStyle( color : Colors.pinkAccent)),
            ],
          ),
        ),
      ),
    );
  }
}
