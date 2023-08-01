import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_button.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                              profileImage: data['image_url'],
                              email: data['email'],
                            ),

                            Column(
                              children: [
                                CustomBtn(
                                  text: "Edit profile",
                                  onTap: () {},
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
        const SizedBox(
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

  const _profileOptions(
      {Key? key, required this.text, required this.icon, required this.tail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          width: 100,
        ),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              Text(
                tail,
                style: const TextStyle(fontSize: 13),
                maxLines: null, // Allow the text to wrap to multiple lines
              ),
            ],
          ),
        )
      ],
    );
  }
}

void _showUserCart(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const UserCart(),
    ),
  );
}

Future _logOut() async {
  await FirebaseAuth.instance.signOut();
}
