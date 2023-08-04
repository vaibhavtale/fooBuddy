import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/menu_card.dart';

class MenuItemPage extends StatefulWidget {
  final MenuCard menuCard;

  const MenuItemPage({Key? key, required this.menuCard}) : super(key: key);

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
      'name': widget.menuCard.foodName,
      'image_url': widget.menuCard.imagePath,
      'price': widget.menuCard.price,
      'quantity' : 0,
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;
    print(docId);

    // Use the update() method to add the itemData to the userCart list
    try {
      await _firestore.collection('users').doc(docId).update({
        'userCart': FieldValue.arrayUnion([itemData])
      });
      print("you got it");
    } catch (e) {
      print(e.toString());
    }
  }

  Future _addItemToSavedList() async{

    Map<String, dynamic> itemData = {
      'name': widget.menuCard.foodName,
      'image_url': widget.menuCard.imagePath,
      'price': widget.menuCard.price,
      'quantity' : 0,
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;
    print(docId);

    // Use the update() method to add the itemData to the userCart list
    try {
      await _firestore.collection('users').doc(docId).update({
        'savedItems': FieldValue.arrayUnion([itemData])
      });
      print("you got it");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore
              .collection('users')
              .where('email', isEqualTo: _auth.currentUser!.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                final data = snapshot.data!.docs.first.data();
                return Center(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          gradient:
                              LinearGradient(colors: [Colors.red, Colors.pink]),
                        ),
                        child: Image.asset(
                          widget.menuCard.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              widget.menuCard.foodName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text("\$" + widget.menuCard.price.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 150, right: 50),
                            child: Text(
                              "Quantity : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red),
                            ),
                          ),
                          Text(
                            "-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text("1"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "+",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: _addItemToSavedList,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15)),
                              width: 70,
                              height: 60,
                              child: Icon(
                                Icons.add_task,
                                size: 30,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () => _addItemToUserCart(),
                              child: CustomNonGradientButton(
                                  onTap: addItemToCart, text: "Add Cart")),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
