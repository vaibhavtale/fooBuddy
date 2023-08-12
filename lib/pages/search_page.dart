import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/menu_style.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({Key? key}) : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  String searchQuery = '';
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _firestore
                .collection('menu')
                .where('name', isEqualTo: searchQuery)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Map<String, dynamic>> productList =
                    snapshot.data!.docs.map((doc) => doc.data()).toList();
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {}),
                                  child: const Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      searchQuery = value;
                                    },
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pinkAccent,
                                          fontSize: 24),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      searchQuery.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: productList.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> menuData =
                                      productList[index];
                                  return MyMenuStyle(
                                    fromSearchPage: true,
                                    data: menuData,
                                  );
                                },
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 270),
                              child: Center(
                                child: Text(
                                  "Search Tasty Food Here.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pinkAccent,
                                      fontSize: 20),
                                ),
                              ),
                            )
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
