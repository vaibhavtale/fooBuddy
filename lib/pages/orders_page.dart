import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'oder_detail.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    super.key,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Recent orders',
          ),
        ),
        backgroundColor: Colors.green[200],
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firestore
            .collection(
              'orders',
            )
            .where(
              'email',
              isEqualTo: _auth.currentUser!.email,
            )
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs.first;
              final order = docs.data();

              final productList = order['products'];

              return ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 25,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetails(
                            id: productList[index]['product_id'],
                            orderData: productList[index],
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            18.0,
                          ),
                          child: ListTile(
                            title: Text(
                              productList[index]['name'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  productList[index]['hotel_name'],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Quantity : ${productList[index]['item_count']}',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            trailing: Text(
                              '\$${productList[index]['item_price']}',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Get your first order Now.',
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
