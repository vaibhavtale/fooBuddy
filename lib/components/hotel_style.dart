import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:foodbuddy/pages/menu_page.dart';

import 'custom_methods.dart';

class HotelStyle extends StatelessWidget {
  final HotelCard hotelCard;

  const HotelStyle({
    Key? key,
    required this.hotelCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _getDocumentId(HotelCard hotelCard) async {
      final docs = await FirebaseFirestore.instance
          .collection('hotels')
          .where('name', isEqualTo: hotelCard.restaurantName)
          .get();

      final docId = docs.docs.first.id;
      print(docId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPage(
            hotelId: docId, hotelName: hotelCard.restaurantName,
          ),
        ),
      );
    }

    return Center(
      child: GestureDetector(
        onTap: () async {
          await _getDocumentId(hotelCard);
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height * 0.23,
              width: 430,
              decoration: BoxDecoration(
                  // color: Colors.red it is not that hard to develop a good working website the one essential ingridient neccesary to do so is to have a problem solving mindset and not to be very static with what you know you will might need to apply for different companies wich works on different technoligies so be always prepared for such oppportunities as it is not easy to get an iterview opprtunity in the todays competitive world so be fearless manage time for different things and it's completely okk if you got rejected but to be affraid to appear for such opprtunities will be an act of stupidity, think it as an adventure you will never be fully prepared so just go for it you will definately learn something new out of it. it is very easy actually but you are getting trapped in your comfort zone so make your mood and you don't need bunch of people to be with you for cracking the interview it dosen't even matter best of luck for tommorow don't make stupid moves just sacrifice todays sleep and you are all set  imean prepared for the ongoing process it's your mind wich wants to postpone such challenging events but you need to be shameless in such situations it will need only few hours and that's it so vaibhya make it happen.
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
              width: 430,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                  color: Colors.black45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    hotelCard.restaurantName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Divider(
                    color: Colors.white24,
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hotelCard.isNonVeg == true
                          ? Text(
                              "Non-Veg",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(''),
                      SizedBox(
                        width: 10,
                      ),
                      hotelCard.isNonVeg == true
                          ? Text(
                              "Veg",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Pure Veg",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
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
