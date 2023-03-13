import 'dart:io';

import 'package:catch_app/utilities/palette.dart';
import 'package:catch_app/main.dart';
import 'package:catch_app/utilities/snack_bar.dart';
import 'package:catch_app/widgets/button_factory.dart';
import 'package:catch_app/widgets/sign_up_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ButtonFactory? _factory;

  @override
  void initState() {
    if (Platform.isIOS) {
      _factory = iOSButtonFactory();
    } else if (Platform.isAndroid) {
      _factory = AndroidButtonFactory();
    }
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 180),
            const Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Palette.mainGreen,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 4),
            TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: _factory?.createButton(signIn, 'Log in'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  RichText(
                      text: TextSpan(
                    text: 'Register here',
                    style: TextStyle(
                        color: Palette.mainGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                  ))
                ],
              ),
            )
          ]),
        ),
      );

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await _firebaseService.signIn(
          emailController.text.trim(), passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      ShowSnackBar.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
