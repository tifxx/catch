import 'package:catch_app/utilities/palette.dart';
import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/login_widget.dart';
import 'package:catch_app/widgets/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
