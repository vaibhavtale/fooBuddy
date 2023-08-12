import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> _updateUserCart(Map<String, dynamic> data, int index) async {
    final List<dynamic> _savedList = data['userCart'];

    _savedList.removeAt(index);

    final userData = await {
      'userCart': _savedList,
    };

    try {
      final docs = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .get();

      final docId = docs.docs.first.id;

      await _firestore.collection('users').doc(docId).update(userData);
      showMessage(context, 'Success userCart has been updated successfully');
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

    final docId = docs.docs.first.id;
    List<dynamic> savedItems = docs.docs.first['userCart'];

    var price = 0;
    for (var i = 0; i < savedItems.length; i++) {
      price += savedItems[i]['price'] as int;
    }
    setState(() {
      _totalPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("UserCart")),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _firestore
                  .collection('users')
                  .where('email', isEqualTo: _auth.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    final data = snapshot.data!.docs.first.data();
                    List userCartList = data['userCart'];
                    return userCartList.isNotEmpty
                        ? ListView.builder(
                            itemCount: userCartList.length,
                            itemBuilder: (context, index) {
                              print(index);
                              return CustomListTile(
                                  data: data,
                                  index: index,
                                  onTap: _updateUserCart);
                            },
                          )
                        : const Center(
                            child: Text("Cart is Empty"),
                          );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // _showTotalPrice()
                    Text(
                      'Total Price  :  \$ ${_totalPrice.toString()} + \$30  =  \$${(_totalPrice + 30)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
