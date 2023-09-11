import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_list_tile.dart';

import '../components/custom_methods.dart';

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<String> priceList = [];
  var _totalPrice = 0;
  Map<String, dynamic>? data;

  Future<void> _updateUserCart(Map<String, dynamic> data, int index) async {
    final List<dynamic> userCart = data['userCart'];

    userCart.removeAt(index);

    final userData = {
      'userCart': userCart,
    };

    try {
      final docs = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .get();

      final docId = docs.docs.first.id;

      await _firestore.collection('users').doc(docId).update(userData);
      showMessage(context, "Success userCart has been updated successfully.");
      _showTotalPrice();
      setState(() {});
    } catch (e) {
      showMessage(context, "Error updating userCart: $e");
    }
  }

  Future<void> _showTotalPrice() async {
    final docs = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    List<dynamic> userCartList = docs.docs.first['userCart'];

    var price = 0;
    for (var i = 0; i < userCartList.length; i++) {
      price += userCartList[i]['price'] as int;
      price *= userCartList[i]['item_count'] as int;
    }
    setState(
      () {
        _totalPrice = price;
      },
    );
  }

  Future<void> _setOrder(Map<String, dynamic> data) async {
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );

    List<Map<String, dynamic>> cartItems = [];
    for (int i = 0; i < data['userCart'].length; i++) {
      cartItems.add(
        {
          'hotel_name': data['userCart'][i]['hotel_name'],
          'item_count': data['userCart'][i]['item_count'],
          'item_price': data['userCart'][i]['price'],
          'other_charges': data['userCart'][i]['other_charges'],
          'product_id': data['userCart'][i]['product_id'],
          'name': data['userCart'][i]['name'],
          'total_price': (data['userCart'][i]['price'] as int) *
              (data['userCart'][i]['item_count'] as int),
          'time': DateTime.now(),
        },
      );
    }
    // Check if the document with the user's email already exists
    QuerySnapshot existingDocs = await _firestore
        .collection('orders')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    if (existingDocs.docs.isNotEmpty) {
      DocumentSnapshot existingDoc = existingDocs.docs.first;
      List<dynamic> existingProducts = existingDoc['products'];
      for (int i = 0; i < cartItems.length; i++) {
        existingProducts.add(cartItems[i]);
      }
      try {
        await existingDoc.reference.update(
          {
            'products': existingProducts,
          },
        );
        showMessage(
          context,
          'Order placed successfully..',
        );
      } catch (e) {
        showMessage(
          context,
          'something went wrong.. try later!',
        );
      }
      return;
    }

    Map<String, dynamic> itemData = {
      'email': _auth.currentUser!.email,
      'address': data['address'],
      'is_processed': false,
      // 'location': GeoPoint(position.latitude, position.longitude),
      'name': data['name'],
      'phone': data['phone_number'],
      'products': cartItems,
    };

    try {
      await _firestore.collection('orders').add(itemData);
      showMessage(
        context,
        'Order has been placed successfully.',
      );
    } catch (e) {
      showMessage(
        context,
        'failed to place order. try later!',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _showTotalPrice(); // Calculate the initial total price when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "UserCart",
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _firestore
                .collection(
                  'users',
                )
                .where(
                  'email',
                  isEqualTo: _auth.currentUser!.email,
                )
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  data = snapshot.data!.docs.first.data();
                  final id = snapshot.data!.docs.first.id;
                  List userCartList = data!['userCart'];

                  return userCartList.isNotEmpty
                      ? ListView.builder(
                          itemCount: userCartList.length,
                          itemBuilder: (context, index) {
                            return CustomListTile(
                              data: data!,
                              index: index,
                              onTap: _updateUserCart,
                              id: id,
                              fromSavedPage: false,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "Cart is Empty",
                          ),
                        );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 80,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  20,
                ),
                child: Text(
                  'Total Price : \$${_totalPrice.toString()} + \$30  =  \$${(_totalPrice + 30)}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: GestureDetector(
              onTap: () => _setOrder(data!),
              child: const CustomNonGradientButton(
                text: 'Place Order',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
