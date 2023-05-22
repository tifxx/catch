import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widgets/upload_picture.dart';

class UploadPicturePage extends StatefulWidget {
  static const routeName = '/uploadPhoto';

  const UploadPicturePage({super.key});

  @override
  State<UploadPicturePage> createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicturePage> {
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
            UploadPicture(),
          ],
        ),
      ),
    );
  }
}
