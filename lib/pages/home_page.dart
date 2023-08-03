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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelStyle(hotelCard: hotelcard),
            );
          }),
      // bottomNavigationBar: MyNavigationBar(),
    );
  }
}
