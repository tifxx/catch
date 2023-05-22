import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:catch_app/model/post.dart';
import 'package:permission_handler/permission_handler.dart';

class ShowMapPage extends StatefulWidget {
  static const routeName = '/showMap';

  const ShowMapPage({Key? key}) : super(key: key);

  @override
  State<ShowMapPage> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {
  @override
  void initState() {
    locatePosition();
    requestPermission();
    super.initState();
  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ReusableWidgets reusableWidgets = ReusableWidgets();
  List<Marker> markers = [];
  List<Post> posts = [];
  List<LatLng> polylineCoordinates = [];
  late geolocator.Position currentPosition;
  var geoLocator = geolocator.Geolocator();

  void locatePosition() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    currentPosition = position;
  }

  Set<Marker> setMarkers(List<Post> listPosts) {
    return listPosts.map((post) {
      LatLng point = LatLng(post.latitude, post.longitude);

      return Marker(
          markerId: MarkerId(post.id),
          position: point,
          infoWindow: InfoWindow(title: 'Location of ${post.title}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () async {
            getPolyPoints(point);
          });
    }).toSet();
  }

  Future<List<LatLng>?> getPolyPoints(LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "API_KEY",
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});

      return polylineCoordinates;
    } else {
      print(result.errorMessage);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableWidgets.getAppBar(context),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(25),
        ),
        Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder<List<Post>>(
                future: _firebaseService.readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Error! ${snapshot.error.toString()}",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    );
                  } else if (snapshot.hasData) {
                    posts = snapshot.data!;
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            final GoogleMapController? _controller = controller;
                          },
                          initialCameraPosition: const CameraPosition(
                              target: LatLng(41.0104591, 20.8756518), zoom: 10),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: setMarkers(posts),
                        ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
      ]),
    );
  }
}
