import 'dart:io';
import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/utilities/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class UploadPicture extends StatefulWidget {
  @override
  _UploadPicturePageState createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicture> {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  File? _image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this._image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        Column(children: [
          ElevatedButton.icon(
            onPressed: pickImage,
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.only(left: 40, right: 40),
                backgroundColor: Palette.mainGreen[100]),
            label: const Text('Click here to open camera',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            icon: const Icon(Icons.photo_camera),
          ),
          ElevatedButton.icon(
            onPressed: (() {
              _firebaseService.uploadPicture(_image!);
            }),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.only(left: 40, right: 40),
                backgroundColor: Palette.mainGreen[100]),
            label: const Text('Upload photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            icon: const Icon(Icons.image),
          ),
        ])
      ],
    );
  }
}
