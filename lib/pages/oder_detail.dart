import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';

class OrderDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic> orderData;
  const OrderDetails({super.key, required this.id, required this.orderData});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.orderData['time'].toDate();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Order details')),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('menu').doc(widget.id).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data();
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(
                                15,
                              ),
                              bottomRight: Radius.circular(
                                15,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                  0.5,
                                ), // Shadow color
                                spreadRadius: 5, // How much the shadow spreads
                                blurRadius: 10, // How blurry the shadow is
                                offset: const Offset(
                                  0,
                                  3,
                                ),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 25,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const BigText(
                                        text: 'Recent order at',
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      BigText(
                                        text: data!['hotel_name'],
                                        color: true,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                  ),
                                  width: 450,
                                  height: 250,
                                  child: Image.network(
                                    data['image_url'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomCircularButton(
                                      icon: Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      data['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '\$${widget.orderData['item_price']}',
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                CustomRow(
                                  text1: 'subTotal',
                                  text2:
                                      '\$ ${(widget.orderData['item_price'] as int) * (widget.orderData['item_count'] as int)}',
                                ),
                                CustomRow(
                                  text1: 'Other charges',
                                  text2:
                                      '\$ ${widget.orderData['other_charges']}',
                                ),
                                const CustomRow(
                                  text1: 'Delivery charge',
                                  text2: '\$ 30',
                                ),
                                const Divider(
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '  Total',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '\$ ${((widget.orderData['item_price'] as int) * (widget.orderData['item_count'] as int)) + (widget.orderData['other_charges'] as int) + 30}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Date : '
                              '$date',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const CustomNonGradientButton(
                              text: 'Order Again',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const CustomGradientButton(
                                gradient: true,
                                text: 'Cancel',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String text1;
  final String text2;
  const CustomRow({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text1), Text(text2)],
      ),
    );
  }
}

class BigText extends StatelessWidget {
  final String text;
  final bool? color;
  const BigText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color != null ? Colors.blue : Colors.black,
        fontSize: 18,
      ),
    );
  }
}
