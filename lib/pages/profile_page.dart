import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_button.dart';
import 'package:foodbuddy/components/profile_with_icon.dart';
import 'package:foodbuddy/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _firestore
                .collection('users')
                .where('email', isEqualTo: _auth.currentUser!.email)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  final data = snapshot.data!.docs.first.data();
                  return SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileIconWithName(
                              name: data['name'],
                              imageUrl: image != null
                                  ? image!.path
                                  : "https://cdn.pixabay.com/photo/2023/02/08/02/40/iron-man-7775599_1280.jpg",
                              email: data['email'],
                              onTap: () {},
                              isEditable: false,
                            ),
                            Column(
                              children: [
                                CustomBtn(
                                  text: "Edit profile",
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile(data: data)));
                                  },
                                  icon: Icons.edit,
                                  loading: _loading,
                                ),
                                CustomBtn(
                                  text: "Recent orders",
                                  onTap: () {},
                                  icon: Icons.shopping_cart_outlined,
                                  loading: _loading,
                                ),
                                CustomBtn(
                                  text: "Call us",
                                  onTap: () {},
                                  icon: Icons.call,
                                  loading: _loading,
                                ),
                                CustomBtn(
                                  text: "Logout",
                                  onTap: () async {
                                    if (!_loading) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await _auth.signOut();
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                                  icon: Icons.arrow_right_alt,
                                  loading: _loading,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
