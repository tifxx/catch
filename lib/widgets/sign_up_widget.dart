import 'dart:io';

import 'package:catch_app/utilities/palette.dart';
import 'package:catch_app/main.dart';
import 'package:catch_app/utilities/snack_bar.dart';
import 'package:catch_app/widgets/profile_picture.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';
import 'button_factory.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
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
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 100),
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
              Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Sign up to see, like and share posts about fishing!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              TextFormField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Username'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (username) => username != null && username.length < 4
                    ? 'Enter minimum 4 characters'
                    : null,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => password != null && password.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
              TextFormField(
                  controller: confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  decoration:
                      const InputDecoration(labelText: 'Confirm password'),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) {
                    if (password == null) return 'Please confirm your password';
                    if (password != passwordController.text)
                      return 'The passwords do not match';
                    return null;
                  }),
              SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.all(1.0),
              child: _factory?.createButton(signUp, 'Register'),
            ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    RichText(
                        text: TextSpan(
                      text: 'Log in here',
                      style: TextStyle(
                          color: Palette.mainGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                    ))
                  ],
                ),
              )
            ]),
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      _firebaseService
          .register(emailController.text.trim(), passwordController.text.trim())
          .then((u) =>
              {_firebaseService.addUsername(usernameController.text.trim())});
    } on FirebaseAuthException catch (e) {
      print(e);
      ShowSnackBar.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
