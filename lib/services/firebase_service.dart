import 'dart:io';

import 'package:catch_app/model/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _firebaseStorage = FirebaseStorage.instance.ref();

  Future signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future register(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future logOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future readCurrentUser() async {
    return await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((response) => response);
  }

  Future addUsername(String username) async {
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'username': username,
          'profilePicture':
              'https://firebasestorage.googleapis.com/v0/b/catch-app-5b1f0.appspot.com/o/defaultProfilePicture.jpeg?alt=media&token=59c5cac3-7a46-4046-adf9-be6eaa71700e'
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void updateProfilePicture(File image) async {
    final ref =
        _firebaseStorage.child('images');
    final task = ref.putFile(image);
    final snapshot = await task;
    final url = await snapshot.ref.getDownloadURL();
    _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({'profilePicture': url})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<Image> getPicture(String pictureFromDb) async {
    var url = await _firebaseStorage.child(pictureFromDb).getDownloadURL();
    return Image.network(url);
  }
}
