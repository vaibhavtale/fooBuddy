import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

import '../components/hotel_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _itemCount = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: CustomGradientText(
            text: "FoodBuddy Online",
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserCart())),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5
                ),
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    _itemCount.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: ListView.builder(
          itemCount: hotelList.length,
          itemBuilder: (context, index) {
            HotelCard hotelcard = hotelList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelStyle(
                hotelCard: hotelcard,
              ),
            );
          },
        )

        // bottomNavigationBar: MyNavigationBar(),
        );
  }
}
