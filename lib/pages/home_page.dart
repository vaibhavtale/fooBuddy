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

  void addHotelToFirestore(HotelCard hotelCard) async {
    // Data for the new hotel document
    Map<String, dynamic> newHotelData = {
      'name': hotelCard.restaurantName,
      'image_url': hotelCard.imagePath,
      'rating': 4.5,
      'address': 'Malkapur, buldhana',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: CustomGradientText(
          text: "FoodBuddy Online",
        ),
        actions: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.grey[200]),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserCart())),
                child: Container(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    _itemCount.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                )),
              ))
        ],
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore
              .collection('users')
              .where('email', isEqualTo: _auth.currentUser!.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!.docs.first.data();
                final List _userCartList = data['userCart'];
                _itemCount = _userCartList.length;
                return ListView.builder(
                    itemCount: hotelList.length,
                    itemBuilder: (context, index) {
                      HotelCard hotelcard = hotelList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HotelStyle(
                          hotelCard: hotelcard,
                        ),
                      );
                    });
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      // bottomNavigationBar: MyNavigationBar(),
    );
  }
}
