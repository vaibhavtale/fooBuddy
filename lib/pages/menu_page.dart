import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_card.dart';
import 'package:foodbuddy/components/menu_style.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

class MenuPage extends StatefulWidget {
  final String hotelId;
  const MenuPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';

  /*void addMenuToHotel(String hotelId, MenuCard menucard) async {
    // Data for the menu subcollection
    Map<String, dynamic> menuData = {
      'name': menucard.foodName,
      'price' : menucard.price,
      'isNonVeg' : menucard.isNonVeg,
      'image_url' : menucard.imagePath,
      'hotel_id' : hotelId,
    };

    // Get a reference to the "hotels" collection

    try {
      // Get a reference to the specific hotel document using the provided hotelId
      DocumentReference hotelDocRef = hotelsCollection.doc(hotelId);

      // Get a reference to the "menu" subcollection within the hotel document
      CollectionReference menuSubcollection = hotelDocRef.collection('menu');

      // Add the menu data to the "menu" subcollection

      await menuSubcollection.add(menuData);

      print('Menu added to Hotel successfully.');
    } catch (e) {
      print('Error adding menu to Hotel: $e');
    }
  }*/

  List<MenuCard> filteredMenuList() {
    if (searchQuery.isEmpty) {
      return menuList;
    } else {
      return menuList
          .where(
            (menu) => menu.foodName.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
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
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserCart(),
              ),
            ),
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: menuCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot hotelDocument =
                          snapshot.data!.docs[index];
                      Map<String, dynamic> hotelData =
                          hotelDocument.data() as Map<String, dynamic>;
                      print(hotelData);

                      // MenuCard menuCard = filteredMenuList()[index];
                      //addMenuToHotel(widget.hotelId, menuCard);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: MyMenuStyle(
                          data: hotelData,
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
                                  child: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
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
