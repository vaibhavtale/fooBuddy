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

  void _getDocumentId(HotelCard hotelCard, String? ID) async{

    final docs = await _firestore
        .collection('hotels')
        .where('name', isEqualTo: hotelCard.restaurantName)
        .get();

    final docId = docs.docs.first.id;
    print(docId);
    ID = docId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: CustomGradientText(
          text: "FoodBuddy Online",
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserCart()))
            },
            icon: Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Icon(Icons.add),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: hotelList.length,
          itemBuilder: (context, index) {
            HotelCard hotelcard = hotelList[index];
            String? customID;
            // _getDocumentId(hotelcard, customID);

            // _firestore.collection('hotels').doc(customID).collection('menu').add;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelStyle(hotelCard: hotelcard,),
            );
          }),
      // bottomNavigationBar: MyNavigationBar(),
    );
  }
}


