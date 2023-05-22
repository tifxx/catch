import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String title;
  final String text;
  final String picture;
  final DateTime postTime;

  final FirebaseAuth auth = FirebaseAuth.instance;
  Post(
      {required this.id,
      required this.userId,
      required this.latitude,
      required this.longitude,
      required this.title,
      required this.text,
      required this.picture,
      required this.postTime}) {}

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': auth.currentUser!.uid,
        'latitude': latitude,
        'longitude': longitude,
        'text': text,
        'picture': picture,
        'postTime': postTime,
        'title': title
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      userId: json['userId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      text: json['text'],
      picture: json['picture'],
      postTime: (json['postTime'] as Timestamp).toDate(),
      title: json['title']);
}
