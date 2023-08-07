import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:foodbuddy/components/menu_card.dart';
import 'package:foodbuddy/components/menu_style.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

import '../components/custom_methods.dart';

class MenuPage extends StatefulWidget {
  final HotelCard hotelCard;

  const MenuPage({
    Key? key,
    required this.hotelCard,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';
  CollectionReference hotelCollection =
      FirebaseFirestore.instance.collection('hotel');
  final _firestore = FirebaseFirestore.instance;

  /*Future<void> _updateUserData(MenuCard menuCard) async {
    try {

      await _firestore.collection('products').add(
          {
            'name' : menuCard.foodName,
            'price': menuCard.price,
            'image_url' : menuCard.imagePath,
            'isNonVeg' : menuCard.isNonVeg,
            'popularity' : 0,
            'description' : "",
          }
      );

      showMessage(
          context, 'Success menu collection added succesfully successfully');
    } catch (e) {
      showMessage(context, "Error adding menu collection: $e");
    }
  }*/

  List<MenuCard> filteredMenuList() {
    if (searchQuery.isEmpty) {
      return menuList;
    } else {
      return menuList
          .where((menu) =>
              menu.foodName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white54
            ),
              child: Padding(
                padding:  EdgeInsets.all(3.0),
                child: IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserCart())),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.deepOrangeAccent,
                      size: 30,
                    )),
              ))
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView.builder(
            itemCount: filteredMenuList().length,
            itemBuilder: (context, index) {
              MenuCard menuCard = filteredMenuList()[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MyMenuStyle(menuCard: menuCard),
              );
            },
          ),
          Container(
            height: 80,
            color: Colors.grey[400],
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 50,
                    width: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
