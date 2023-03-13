import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widgets/profile_picture.dart';

class ProfilePicturePage extends StatefulWidget {
  static const routeName = '/profilePicture';

  const ProfilePicturePage({super.key});

  @override
  State<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ReusableWidgets reusableWidgets = ReusableWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableWidgets.getAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfilePicture(),
          ],
        ),
      ),
    );
  }
}
