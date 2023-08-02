import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_button.dart';
import 'package:foodbuddy/pages/edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  File? image;
  Future _takePhotoFromGallery(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);
    try {
      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

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
                            _ProfileIconWithName(
                              name: data['name'],
                              profileImage: image != null
                                  ? Image.file(
                                      image!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "https://cdn.pixabay.com/photo/2023/02/08/02/40/iron-man-7775599_1280.jpg",
                                      width: 100,
                                      height: 100,
                                    ),
                              email: data['email'],
                              onTap: (){_takePhotoFromGallery(ImageSource.gallery);}  ,
                            ),
                            Column(
                              children: [
                                CustomBtn(
                                  text: "Edit profile",
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile()));
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

void _editProfileInfo() {}

class _ProfileIconWithName extends StatelessWidget {
  final String name;
  final Image profileImage;
  final String email;
  final VoidCallback onTap;

  const _ProfileIconWithName(
      {required this.name,
      required this.profileImage,
      required this.email,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipOval(
              child: profileImage,
            ),
            Positioned(
              child: IconButton(
                color: Colors.blueAccent,
                icon: Icon(Icons.add_a_photo, color: Colors.white, size: 25,), onPressed: onTap,
              ),
              right: 10,
              bottom: 10,
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
