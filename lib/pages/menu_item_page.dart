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
  int _itemCount = 1;

  Future<void> _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'item_count': _itemCount,
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;
    List<dynamic> userCartList = docs.docs.first['userCart'];

    int existIndex =
        userCartList.indexWhere((item) => item['name'] == itemData['name']);

    if (existIndex == -1) {
      userCartList.add(itemData);
    } else {
      userCartList[existIndex]['item_count'] = _itemCount;
    }

    try {
      await _firestore.collection('users').doc(docId).update({
        'userCart': userCartList,
      });
      showMessage(context, 'successfully added item to user cart');
    } catch (e) {
      showMessage(context, 'failed to add item');
    }
  }

  void _incrementCounter(bool increment) {
    increment ? _itemCount++ : _itemCount--;
  }

  Future<void> _addItemToSavedList() async {
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'item_count': _itemCount,
      'hotel_id': widget.data['hotel_id'],
    };

    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    final docId = docs.docs.first.id;
    List<dynamic> savedItems = docs.docs.first['savedItems'];

    int existIndex =
        savedItems.indexWhere((item) => item['name'] == itemData['name']);

    if (existIndex == -1) {
      savedItems.add(itemData);
    } else {
      savedItems[existIndex]['item_count'] = _itemCount;
    }

    try {
      await _firestore.collection('users').doc(docId).update({
        'savedItems': savedItems,
      });
      showMessage(context, 'Product added to savedList successfully.');
    } catch (e) {
      e.toString();
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
              // final menuData = snapshot.data!.docs.first.data();
              return Center(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        gradient:
                            LinearGradient(colors: [Colors.red, Colors.pink]),
                      ),
                      child: Image.asset(
                        widget.data['image_url'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            widget.data['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text("\$${widget.data['price']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Quantity : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _incrementCounter(true);
                                    });
                                  },
                                  child: const CustomCircularButton(
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
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_itemCount <= 0) return;
                                    setState(() {
                                      _incrementCounter(false);
                                    });
                                  },
                                  child: const CustomCircularButton(
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
                    const SizedBox(
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
                          child: const CustomGradientButton(
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
                            child: const CustomNonGradientButton(
                                text: "Add Cart")),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
