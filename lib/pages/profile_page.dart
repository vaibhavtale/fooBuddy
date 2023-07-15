import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future signOutUser() async {
    print('Before sign out: ${FirebaseAuth.instance.currentUser}');
    await FirebaseAuth.instance.signOut();
    print('After sign out: ${FirebaseAuth.instance.currentUser}');


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 30,
            ),
            GradientText(
              "Your Profile",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              colors: [Colors.orangeAccent, Colors.redAccent],
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "celebrate the foodie in you.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Email...",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password...",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: [
                    Colors.orangeAccent,
                    Colors.deepOrangeAccent,
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: GestureDetector(
                  // WE WANT TO DO THE UPDATE USER DATA OPERATION OVER HER
                  child: Text(
                    "Apply Changes",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: [
                    Colors.pinkAccent,
                    Colors.orangeAccent,
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: GestureDetector(
                  onTap: ()=> signOutUser(),
                  // WE WANT TO DO THE UPDATE USER DATA OPERATION OVER HER
                  child: Text(
                    "LogOut",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
