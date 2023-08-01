import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/customs/custom_button.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        leading: Icon(
          Icons.navigate_before,
          color: Colors.black,
        ),
        title: Center(
          child: Text(
            "My Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          // Logout Button
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: _logOut,
          ),
        ],
      ),
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
                              profileImage: data['image_url'],
                              email: data['email'],
                            ),

                            CustomBtn(
                                text: "Edit Profile", onTap: _editProfileInfo),

                            SizedBox(
                              height: 30,
                            ),

                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 100,),
                                  child: _profileOptions(
                                    text: "Contact",
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.blue,
                                    ),
                                    tail: data["phone_number"],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: _profileOptions(
                                    text: "address",
                                    icon: Icon(
                                      Icons.local_post_office,
                                      color: Colors.blue,
                                    ),
                                    tail: data["address"],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: _profileOptions(
                                    text: "Recent order",
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    tail: data["phone_number"],
                                  ),
                                ),
                              ],
                            ),


                            Divider(
                              color: Colors.grey,
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () { _showUserCart(context);},
                                  child: _customPageRout(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      text: "my cart",
                                      onTap: _showUserCart),
                                ),
                                _customPageRout(
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    text: "call us",
                                    onTap: _showUserCart),

                              ],
                            )

                            // cart
                            // past orders
                            // call us
                            // logout
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
  final String profileImage;
  final String email;

  const _ProfileIconWithName(
      {required this.name, required this.profileImage, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(profileImage),
        ),
        SizedBox(height: 15),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
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

class _profileOptions extends StatelessWidget {
  final Icon icon;
  final String text;
  final String tail;

  const _profileOptions({Key? key, required this.text, required this.icon, required this.tail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          icon,
          SizedBox(width: 20,),
          Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),),
          SizedBox(width: 100,),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                Text(
                  tail,
                  style: TextStyle(fontSize: 13),
                  maxLines: null, // Allow the text to wrap to multiple lines
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _customPageRout extends StatelessWidget {
  final String text;
  final Icon icon;
  final void onTap;

  const _customPageRout(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent,
              Colors.deepPurpleAccent,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 45,
              ),
              icon,
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showUserCart(BuildContext context) {
Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserCart(),),);
}

Future _logOut() async {
  await FirebaseAuth.instance.signOut();
}
