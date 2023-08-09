import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/hotel_card.dart';
import 'package:foodbuddy/components/menu_card.dart';
import 'package:foodbuddy/components/menu_style.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

import '../components/custom_methods.dart';

class MenuPage extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  const MenuPage({Key? key, required this.hotelId, required this.hotelName}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

/*  Future<void> removeDuplicatesFromSubcollection(String hotelId, String menu) async {
    // Reference to the subcollection
    CollectionReference subcollectionRef = FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelId)
        .collection(menu);

    // Query the subcollection
    QuerySnapshot snapshot = await subcollectionRef.get();

    // Map to track the unique keys
    Map<String, DocumentSnapshot> uniqueKeys = {};

    // Loop through the documents and identify duplicates
    for (DocumentSnapshot doc in snapshot.docs) {
      // Assuming 'fieldToCheck' is the field that determines duplicates
      String fieldValue = doc['name'];

      if (!uniqueKeys.containsKey(fieldValue)) {
        // Add the document to the map if the key is not present
        uniqueKeys[fieldValue] = doc;
      } else {
        // Delete the duplicate document
        await subcollectionRef.doc(doc.id).delete();
      }
    }
  }*/

  Future _addItemsToProducts(Map<String, dynamic> data) async{

    await _firestore.collection('products').add(
      {
        'name' : data['name'],
        'hotel_id' : data['hotel_id'],
        'hotel_name' : widget.hotelName,
        'price' : data['price'],
        'image_url' : data['image_url'],
        'isNonVeg' : data['isNonVeg']
      }
    );
  }

  List<Map<String, dynamic>> filteredMenuList(QuerySnapshot snapshot) {
    if (searchQuery.isEmpty) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } else {
      return snapshot.docs
          .where(
            (doc) => (doc['name'] as String)
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
          )
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference menuCollection = FirebaseFirestore.instance
        .collection('hotels')
        .doc(widget.hotelId)
        .collection('menu');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        actions: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.white54),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
      body: FutureBuilder<QuerySnapshot>(
          future: menuCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> menuList =
                  filteredMenuList(snapshot.data!);

              // removeDuplicatesFromSubcollection(widget.hotelId, 'menu');

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: menuList.length,
                    itemBuilder: (context, index) {
                      // MenuCard menuCard = filteredMenuList()[index];
                      //addMenuToHotel(widget.hotelId, menuCard);
                      Map<String, dynamic> menuData = menuList[index];

                      // _addItemsToProducts(menuData);

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: MyMenuStyle(
                          data: menuData,
                        ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () => setState(() {}),
                                    child: Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      searchQuery = value;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
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
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
