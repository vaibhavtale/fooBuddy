import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_style.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

class MenuPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const MenuPage({Key? key, required this.data}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle, color: Colors.white54),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserCart())),
                  icon: const Icon(Icons.shopping_cart,
                      color: Colors.deepOrangeAccent, size: 30)),
            ),
          )
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: _firestore
              .collection('menu')
              .where('hotel_name', isEqualTo: widget.data!['name'])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> productList = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> menuData = productList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: MyMenuStyle(data: menuData),
                      );
                    },
                  ),
                  Container(
                    height: 80,
                    color: Colors.grey[400],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            height: 50,
                            width: 270,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white70,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () => setState(() {}),
                                    child: const Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      searchQuery = value;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
