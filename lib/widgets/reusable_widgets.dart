import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';
import '../utilities/palette.dart';

class ReusableWidgets {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  getAppBar(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        height: 32,
        alignment: Alignment.centerLeft,
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      shadowColor: Palette.mainGreen,
      actions: [
        PopupMenuButton(
            icon: Icon(
              Icons.menu,
              color: Palette.mainGreen,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(children: [
                    Icon(Icons.home),
                    Text(" Home"),
                  ]),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(children: [
                    Icon(Icons.person),
                    Text(" My Account"),
                  ]),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(children: [
                    Icon(Icons.add),
                    Text(" Add post"),
                  ]),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Row(children: [
                    Icon(Icons.location_on_outlined),
                    Text(" Show map"),
                  ]),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Row(children: [
                    Icon(Icons.logout),
                    Text(" Log out"),
                  ]),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.pushNamed(context, '/home');
              } else if (value == 1) {
                Navigator.pushNamed(context, '/myAccount');
              } else if (value == 2) {
                Navigator.pushNamed(context, '/addPost');
              } else if (value == 3) {
                Navigator.pushNamed(context, '/showMap');
              } else if (value == 4) {
                _firebaseService.logOut();
                Navigator.pushNamed(context, '/auth');
              }
            }),
      ],
    );
  }
}
