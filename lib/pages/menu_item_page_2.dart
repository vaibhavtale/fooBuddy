import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custom_gradient_text.dart';
import '../components/custom_methods.dart';
import 'login_page.dart';

class MenuItem extends StatefulWidget {
  final Map<String, dynamic> data;

  MenuItem({super.key, required this.data});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem>
    with SingleTickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _itemCount = 1;

  Future _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
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
    print(docId);

    // Use the update() method to add the itemData to the userCart list
    try {
      await _firestore.collection('users').doc(docId).update({
        'userCart': FieldValue.arrayUnion([itemData])
      });
      showMessage(context, 'Product added to UserCart succesfully.');
    } catch (e) {
      print(e.toString());
    }
  }

  void _incrementCounter(bool icreament) {
    icreament ? _itemCount++ : _itemCount--;
  }

  Future _addItemToSavedList() async {
    Map<String, dynamic> itemData = {
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
    print(docId);

    // Use the update() method to add the itemData to the userCart list
    try {
      await _firestore.collection('users').doc(docId).update({
        'savedItems': FieldValue.arrayUnion([itemData])
      });
      showMessage(context, 'Product added to savedList succesfully.');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
//
              const Padding(
                padding: EdgeInsets.only(left: 150, right: 50),
                child: Text(
                  "Quantity : ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
              ),
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
    ;
  }
}
