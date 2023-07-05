// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/loader.dart';
import '../components/text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  // final Function()? onTap;
  const RegisterPage({
    super.key,
    //  required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    void displayMessage(String message) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message),
              ));
    }

    final emailTextController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void signUp() async {
      showDialog(context: context, builder: (context) => Loader());

      if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        displayMessage('Passwords didn\'t match');
        return;
      }
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordController.text);
        FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.email)
            .set({
          'userName': emailTextController.text.split('@')[0],
          'bio': ''
        });
        setState(() {});
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessage(e.code);
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 150,
              color: Colors.white,
            ),
            SizedBox(
              height: 30,
            ),
            Text('Let\'s create your account',
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 30,
            ),
            MyTextField(
                controller: emailTextController,
                hintText: 'Email',
                tColor: Colors.white,
                obscureText: false),
            SizedBox(
              height: 30,
            ),
            MyTextField(
                controller: passwordController,
                hintText: 'Password',
                tColor: Colors.white,
                obscureText: true),
            SizedBox(
              height: 30,
            ),
            MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                tColor: Colors.white,
                obscureText: true),
            SizedBox(
              height: 30,
            ),
            MyButton(onTap: signUp, text: 'Sign Up'),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already a member?',
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Login here',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
