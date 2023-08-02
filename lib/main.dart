import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/my_bottom_nav_bar.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

/*
Platform  Firebase App Id
web       1:293751067507:web:f89d226819c1a15bb5eb06
android   1:293751067507:android:8c1f6c6705bea8bbb5eb06
ios       1:293751067507:ios:cb4ffda2e06d301fb5eb06
macos     1:293751067507:ios:21a24aee6bf2c3c1b5eb06
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> simulatorAppLoading() async {
    await Future.delayed(Duration(seconds: 1));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: simulatorAppLoading(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return MyNavigationBar();
            }
          },
        ));
  }
}
