import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_style.dart';
import 'package:foodbuddy/pages/user_cart_page.dart';

class MenuPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const MenuPage({
    Key? key,
    required this.data,
  }) : super(
          key: key,
        );

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
          title: Center(
            child: Text(
              widget.data!['name'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          backgroundColor: Colors.lightGreen[300],
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserCart(),
                  ),
                ),
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                  weight: 800,
                  size: 30,
                ),
              ),
            ),
          ]),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore
              .collection(
                'menu',
              )
              .where(
                'hotel_name',
                isEqualTo: widget.data!['name'],
              )
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> productList = snapshot.data!.docs
                  .map(
                    (doc) => doc.data(),
                  )
                  .toList();
              List<Map<String, dynamic>> filteredMenuList = [];

              // for(int i=0; i<productList.length; i++){
              //
              //   if(productList[i]['name'].contains(searchQuery)){
              //
              //     filteredMenuList.a
              //   }
              // }

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      Map<String, dynamic> menuData = doc.data();
                      String docId = doc.id; // This is the document ID
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: MyMenuStyle(
                          data: menuData,
                          id: docId,
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 80,
                    color: Colors.grey[400],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              color: Colors.white70,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () {},
                                    ),
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
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    10,
                                  ),
                                  bottomLeft: Radius.circular(
                                    10,
                                  ),
                                ),
                                color: Colors.white24,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                                child: Text(
                                  'Veg',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    10,
                                  ),
                                  bottomRight: Radius.circular(
                                    10,
                                  ),
                                ),
                                color: Colors.white24,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Text(
                                  'Non Veg',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
