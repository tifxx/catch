import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:catch_app/model/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/button_factory.dart';
import 'dart:io';
import 'package:catch_app/services/firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? _controller;
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ButtonFactory? _factory;
  List<Marker> markers = [];
  int id = 1;
  late LatLng _latLng;

  @override
  void initState() {
    if (Platform.isIOS) {
      _factory = iOSButtonFactory();
    } else if (Platform.isAndroid) {
      _factory = AndroidButtonFactory();
    }
    super.initState();
  }

  void submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String image = prefs.getString('image').toString();
    Random random = new Random();
    Post post = Post(
        id: random.nextInt(1000).toString(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        latitude: _latLng.latitude,
        longitude: _latLng.longitude,
        title: titleController.text,
        text: textController.text,
        picture: image,
        postTime: DateTime.now());

    _firebaseService.addPostToDB(post: post);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Post title',
                  border: OutlineInputBorder(),
                ),
                controller: titleController,
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Post text',
                  border: OutlineInputBorder(),
                ),
                controller: textController,
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 150,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(41.0104591, 20.8756518),
                    zoom: 10,
                  ),
                  onTap: (LatLng latLng) {
                    Marker marker = Marker(
                      markerId: MarkerId('$id'),
                      position: LatLng(latLng.latitude, latLng.longitude),
                      infoWindow: InfoWindow(title: 'Location for your catch'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    );
                    markers.add(marker);
                    _latLng = latLng;
                    setState(() {});
                    id = id + 1;
                  },
                  markers: markers.map((e) => e).toSet(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: _factory?.createButton(
                    () => Navigator.pushNamed(context, '/uploadPhoto'),
                    'Upload photo'),
              ),
              TextButton(
                onPressed: submitData,
                child: const Text('Publish post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
