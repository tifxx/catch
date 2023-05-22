import 'package:flutter/material.dart';
import 'package:catch_app/model/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;

  const PostsList({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
            elevation: 5,
            child: Column(
              children: [
                Text(
                  posts[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text(
                      "${DateFormat("dd/MM/yyyy h:mma").format(posts[index].postTime)}"),
                  subtitle: Text(posts[index].text),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 175,
                      height: 200,
                      child: Container(
                        child: Image.network(posts[index].picture,
                            height: 150.0, width: 150.0, fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                      height: 200,
                    ),
                    SizedBox(
                      width: 175,
                      height: 200,
                      child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            final GoogleMapController? _controller = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                posts[index].latitude, posts[index].longitude),
                            zoom: 10,
                          ),
                          markers: {
                            Marker(
                                markerId: MarkerId(posts[index].toString()),
                                position: LatLng(posts[index].latitude,
                                    posts[index].longitude)),
                          }),
                    ),
                  ],
                ),
              ],
            ));
      },
      itemCount: posts.length,
    );
  }
}
