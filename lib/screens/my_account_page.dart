import 'dart:io';

import 'package:catch_app/model/app_user.dart';
import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/profile_picture.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widgets/button_factory.dart';

class MyAccountPage extends StatefulWidget {
  static const routeName = '/myAccount';

  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ReusableWidgets reusableWidgets = ReusableWidgets();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableWidgets.getAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'My Account',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: FutureBuilder<dynamic>(
                    future: _firebaseService.readCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          "Error! ${snapshot.error.toString()}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        );
                      } else if (snapshot.hasData) {
                        AppUser appUser = AppUser.fromJson(snapshot.data.data());
                        return Column(children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(appUser.picture,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.fill),
                            ),
                            padding: EdgeInsets.all(15),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: _factory?.createButton(
                                () => Navigator.pushNamed(
                                    context, '/profilePicture'),
                                'Change Profile Picture'),
                          ),
                          Container(
                              child: Text(
                                  'Username: ${appUser.username}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              padding: EdgeInsets.all(5)),
                          Container(
                              child: Text(
                                  'Email: ${_firebaseService.getCurrentUser()?.email}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              padding: EdgeInsets.all(5))
                        ]);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
