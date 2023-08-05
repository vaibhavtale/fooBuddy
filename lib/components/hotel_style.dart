import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:foodbuddy/pages/menu_page.dart';

import 'custom_methods.dart';

class HotelStyle extends StatelessWidget {
  final HotelCard hotelCard;

  const HotelStyle({Key? key, required this.hotelCard,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuPage(
                      hotelCard: hotelCard,
                    ))),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height * 0.21,
              width: 500,
              decoration: BoxDecoration(
                  // color: Colors.red
                  ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    hotelCard.imagePath,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                  color: Colors.black45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hotelCard.restaurantName,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Divider(
                    color: Colors.white24,
                    height: 7,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Non-Veg",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Veg",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
