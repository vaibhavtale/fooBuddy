import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/login_page.dart';
import 'package:foodbuddy/pages/profile_page.dart';

class TogglePage extends StatelessWidget {
  const TogglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfilePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
