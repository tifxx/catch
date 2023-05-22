import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:catch_app/widgets/new_post.dart';
import '../widgets/button_factory.dart';
import 'dart:io';

class AddPostPage extends StatefulWidget {
  static const routeName = '/addPost';

  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  ReusableWidgets reusableWidgets = ReusableWidgets();
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ButtonFactory? _factory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableWidgets.getAppBar(context),
      body: Center(child: NewPost()),
    );
  }
}
