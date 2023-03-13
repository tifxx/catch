import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppUser {
  final String username;
  final String picture;

  AppUser({
    required this.username,
    required this.picture,
  });

    Map<String, dynamic> toJson() => {
    'username': username,
    'picture': picture,
  };

  static AppUser fromJson(Map<String, dynamic> json) => AppUser(
    username: json['username'],
    picture: json['profilePicture'],
    );
}