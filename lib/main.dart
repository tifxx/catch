import 'package:catch_app/screens/my_account_page.dart';
import 'package:catch_app/utilities/palette.dart';
import 'package:catch_app/screens/auth_page.dart';
import 'package:catch_app/screens/home_page.dart';
import 'package:catch_app/services/firebase_service.dart';
import 'package:catch_app/utilities/snack_bar.dart';
import 'package:catch_app/widgets/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import 'screens/profile_picture_page.dart';
import 'package:catch_app/screens/add_post.dart';
import 'package:catch_app/screens/show_map.dart';
import 'package:catch_app/screens/upload_picture_page.dart';

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupSingletons();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
    return MaterialApp(
      scaffoldMessengerKey: ShowSnackBar.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Catch',
      theme: ThemeData(
          primarySwatch: Palette.mainGreen,
          scaffoldBackgroundColor: Colors.white),
      home: StreamBuilder(
        stream: _firebaseService.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
      routes: {
        AuthPage.routeName: (context) => AuthPage(),
        HomePage.routeName: (context) => const HomePage(),
        MyAccountPage.routeName: (context) => const MyAccountPage(),
        AddPostPage.routeName: (context) => const AddPostPage(),
        ShowMapPage.routeName: (context) => const ShowMapPage(),
        ProfilePicturePage.routeName: (context) => const ProfilePicturePage(),
        UploadPicturePage.routeName: (context) => const UploadPicturePage(),
      },
    );
  }
}
