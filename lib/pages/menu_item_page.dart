import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/pages/login_page.dart';

class MenuItemPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const MenuItemPage({Key? key, required this.data}) : super(key: key);

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _itemCount = 0;

  Future<void> _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
      'hotel_id': widget.data['hotel_id'],
      // Assuming 'hotelId' is a unique identifier for the hotel
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'quantity': _itemCount,
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;

    List<dynamic> userCart = docs.docs.first['userCart'];

    // Check if the item with the same 'hotelId' already exists in userCart
    bool itemExists = false;
    for (var i = 0; i < userCart.length; i++) {
      if (userCart[i]['hotel_id'] == itemData['hotel_id']) {
        itemExists = true;

        // Update the itemCount of the existing item
        userCart[i]['quantity'] = _itemCount;
        break;
      }
    }

    // If the item doesn't exist, add it to the cart
    if (!itemExists) {
      userCart.add(itemData);
    }

    // Use the update() method to update the userCart list
    try {
      await _firestore.collection('users').doc(docId).update({
        'userCart': userCart,
      });
      showMessage(context, 'Product added to UserCart successfully.');
    } catch (e) {
      print(e.toString());
    }
  }

  void _incrementCounter(bool icreament) {
    icreament ? _itemCount++ : _itemCount--;
  }

  Future<void> _addItemToSavedList() async {
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'quantity': _itemCount,
      'hotel_id' : widget.data['hotel_id'],
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;
    print(docId);

    List<dynamic> savedItems = docs.docs.first['savedItems'];

    // Check if the item with the same 'name' already exists in savedItems
    bool itemExists = false;
    for (var i = 0; i < savedItems.length; i++) {
      if (savedItems[i]['name'] == itemData['name']) {
        itemExists = true;

        // Update the quantity of the existing item
        savedItems[i]['quantity'] = _itemCount;
        break;
      }
    }

    // If the item doesn't exist, add it to the list
    if (!itemExists) {
      savedItems.add(itemData);
    }

    // Use the update() method to update the savedItems list
    try {
      await _firestore.collection('users').doc(docId).update({
        'savedItems': savedItems,
      });
      showMessage(context, 'Product added to savedList successfully.');
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
                  final menuData = snapshot.data!.docs.first.data();
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            gradient: LinearGradient(colors: [Colors.red, Colors.pink]),
                          ),
                          child: Image.asset(
                            widget.data['image_url'],
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
                                widget.data['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text("\$" + widget.data['price'].toString(),
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
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Quantity : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.red),
                                ),
                                SizedBox(width: 50,),
                                Row(

                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _incrementCounter(true);
                                        });
                                      },
                                      child: CustomCircularButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(_itemCount.toString()),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_itemCount <= 0) return;
                                        setState(() {
                                          _incrementCounter(false);
                                        });
                                      },
                                      child: CustomCircularButton(
                                        icon: Icon(
                                          Icons.minimize_outlined,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
//


                          ],
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () => _auth.currentUser != null
                                  ? _addItemToSavedList()
                                  : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        fromMenuItemPage: true,
                                      ))),
                              child: CustomGradientButton(
                                text: 'Save',
                                gradient: true,
                              ),
                            ),
                            GestureDetector(
                                onTap: () => _auth.currentUser != null
                                    ? _addItemToUserCart()
                                    : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage(
                                          fromMenuItemPage: true,
                                        ))),
                                child: CustomNonGradientButton(text: "Add Cart")),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            )
    );
  }
}
