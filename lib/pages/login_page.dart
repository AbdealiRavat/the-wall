// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:WallApp/components/button.dart';
import 'package:WallApp/components/text_field.dart';
import 'package:WallApp/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  // final Function()? onTap;
  const LoginPage({
    super.key,
    //  required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    String myText = Provider.of<String>(context);
    final emailTextController = TextEditingController();
    final passwordController = TextEditingController();

    void signIn() async {
      print(emailTextController.text.trim());
      print(passwordController.text.trim());
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e.message);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Invalid User Credentials'),
                ));
      }
      setState(() {});
    }

    return MaterialApp(
      home: Scaffold(
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
            Text(myText, style: TextStyle(color: Colors.white)),
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
            MyButton(onTap: signIn, text: 'Login'),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?', style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('Regiter here',
                        style: TextStyle(color: Colors.blue))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
