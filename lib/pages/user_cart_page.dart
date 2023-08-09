import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custom_gradient_text.dart';
import '../components/custom_methods.dart';
import '../components/menu_card.dart';
import 'menu_item_page.dart';

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
    } catch (e) {
      showMessage(context, "Error updating userCart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserCart"),
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                          itemCount: data['userCart'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 20, left: 35, right: 35),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 5, // How much the shadow spreads
                                    blurRadius: 10, // How blurry the shadow is
                                    offset: Offset(0, 3),
                                  )
                                ],
                                  borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MenuItemPage(
                                            data: data['userCart'][index],
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 60,
                                            child: Image.asset(
                                              data['userCart'][index]['image_url'],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['userCart'][index]['name'],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Item - ' +
                                                    data['userCart'][index]
                                                            ['quantity']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Price - \$' +
                                                    data['userCart'][index]['price']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black45,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await _updateUserCart(data, index);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.pinkAccent,
                                          size: 35,
                                        ),),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text("Cart is Empty"));
                }
              }
              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        ],
      ),
    );
  }
}
