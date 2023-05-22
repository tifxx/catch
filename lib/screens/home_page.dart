import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:catch_app/model/post.dart';
import '../widgets/posts_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  ReusableWidgets reusableWidgets = ReusableWidgets();
  List<Post> posts = [];

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
                        height: 600,
                        child: posts.isEmpty
                            ? const Text('There are no posts',
                                textAlign: TextAlign.center)
                            : PostsList(posts: posts));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
      ]),
    );
  }
}
