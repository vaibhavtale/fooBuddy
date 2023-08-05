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

  void addHotelToFirestore(HotelCard hotelCard) async {
    // Data for the new hotel document
    Map<String, dynamic> newHotelData = {
      'name': hotelCard.restaurantName,
      'image_url' : hotelCard.imagePath,
      'rating' : 4.5,
      'address' : 'Malkapur, buldhana',
      // Add more fields as needed
    };

    // Get a reference to the "hotels" collection
    CollectionReference hotelsCollection =
    FirebaseFirestore.instance.collection('hotels');

    // Add the document to the "hotels" collection
    try {
      await hotelsCollection.add(newHotelData);
      print('Document added successfully.');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  void _getDocumentId(HotelCard hotelCard,) async{


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
            _getDocumentId(hotelcard,);
            // addHotelToFirestore(hotelcard);
            
            // _firestore.collection('hotels').doc(customID).collection('menu');

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelStyle(hotelCard: hotelcard),
            );
          }),
      // bottomNavigationBar: MyNavigationBar(),
    );
  }
}


