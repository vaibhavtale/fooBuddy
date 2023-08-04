import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/menu_card.dart';

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserCart"),
      ),
      body:FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore
              .collection('users')
              .where('email', isEqualTo: _auth.currentUser!.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                final data = snapshot.data!.docs.first.data();
                return ListView.builder(
                  itemCount: data['userCart'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset(data['userCart'][index]['image_url']),
                            title: Text(data['userCart'][index]['name']),
                            subtitle: Text(
                              "\$ " + data['userCart'][index]['price'].toString(),
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.redAccent,
                              onPressed: () {
                                setState(() {
                                  data['userCart'][index];
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else{
                return Center(child: Text("Cart is Empty"));
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),

    );
  }
}
