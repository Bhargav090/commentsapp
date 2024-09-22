// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:commentsapp/screens/home_screen.dart';
import 'package:commentsapp/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('User logged in: ${userCredential.user}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User does not exist. Please sign up.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset('assets/authdisplay.json'),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Email Field--------------------------
                  Padding(
                    padding: EdgeInsets.all(Height * 0.015),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        email = value; 
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height:Height * 0.01),
                  // Password Field--------------------------------
                  Padding(
                    padding: EdgeInsets.all(Height * 0.015),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        password = value; 
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: Height * 0.16),
                  Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: Width * 0.04),
                          backgroundColor: const Color.fromRGBO(12, 84, 190, 1),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //logging in the user---------------
                            loginUser(email, password);
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New here? ',
                    style: TextStyle(
                      fontSize: Height * 0.02,
                      fontWeight: FontWeight.w500,
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Text('Signup',
                        style: TextStyle(
                            fontSize: Height * 0.02,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(12, 84, 190, 1)))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
