import 'package:flutter/material.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
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
        title: GradientText(
          "FoodBuddy Online",
          style: TextStyle(
              color: Colors.red[400],
              fontWeight: FontWeight.bold,
              fontSize: 30),
          colors: [Colors.red, Colors.redAccent],
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Icon(Icons.add),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            HotelCard hotelcard = new HotelCard(
                imagePath: "images/f2.jpg",
                restaurantName: "Hotel Surya",
                nonVeg: true);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelStyle(hotelCard: hotelcard),
            );
          }),
      // bottomNavigationBar: MyNavigationBar(),
    );
  }
}
