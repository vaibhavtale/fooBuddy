import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/menu_card.dart';
import 'package:foodbuddy/pages/login_page.dart';
import 'package:foodbuddy/pages/menu_item_page_2.dart';

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

  Future _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'quantity': 0,
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
      'quantity': 0,
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
    return Scaffold(
      appBar: AppBar(),
      body: _auth.currentUser != null
          ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _firestore
                  .collection('users')
                  .where('email', isEqualTo: _auth.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final menuData = snapshot.data!.docs.first.data();
                  return MenuItem(
                    data: widget.data,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : MenuItem(
              data: widget.data,
            ),
    );
  }
}
