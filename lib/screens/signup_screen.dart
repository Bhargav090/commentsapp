// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commentsapp/screens/home_screen.dart';
import 'package:commentsapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';

  // Register user with Firebase------------------------------------
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('User: ${userCredential.user}');
      return userCredential.user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Store user details in Firestore-------------------------------
  Future<void> storeUserDetails(String name, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
    });
  }

  // Checking if the user already exists------------------------------
  Future<bool> checkUserExists(String email) async {
    final List<User> userList = FirebaseAuth.instance.currentUser != null
        ? [FirebaseAuth.instance.currentUser!]
        : [];
    return userList.isNotEmpty;
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
                  // Name Field---------------------
                  Padding(
                    padding: EdgeInsets.all(Height * 0.015),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        name = value;
                        return null;
                      },
                    ),
                  ),
                  // Email Field------------------------
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
                  // Password Field------------------------------
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
                  SizedBox(height: Height * 0.069),
                  // Submit Button
                  Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: Width * 0.04),
                          backgroundColor: const Color.fromRGBO(12, 84, 190, 1),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              bool userExists = await checkUserExists(email);
                              if (userExists) {
                                // Display alert: User already exists------------
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'User already exists, please log in.'),
                                  ),
                                );
                              } else {
                                // Register user------------------------------
                                await registerUser(email, password);
                                await storeUserDetails(name, email);
                                // Navigate to the home screen--------------------
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            } catch (e) {
                              // Handling error-------------
                              print('Error: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error creating account'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ',
                    style: TextStyle(
                      fontSize: Height * 0.02,
                      fontWeight: FontWeight.w500,
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: Height * 0.02,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(12, 84, 190, 1))))
              ],
            )
          ],
        ),
      ),
    );
  }
}
