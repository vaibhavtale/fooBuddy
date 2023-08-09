import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>>? _productList;

  List<Map<String, dynamic>> filteredMenuList(QuerySnapshot snapshot) {
    if (searchQuery.isEmpty) {
      return [];
    } else {
      return snapshot.docs
          .where(
            (doc) => (doc['name'] as String)
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
          )
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _firestore.collection('products').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _productList = filteredMenuList(snapshot.data!);
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
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
                                  child: Icon(
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
                                    style: TextStyle(
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
                                itemCount: _productList!.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> menuData =
                                      _productList![index];
                                  return MyMenuStyle(
                                    fromSearchPage: true,
                                    data: menuData,
                                  );
                                },
                              ),
                            )
                          : Padding(
                            padding: const EdgeInsets.only(top: 270),
                            child: Center(
                                child: Text("Search Tasty Food Here.", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent,
                                    fontSize: 20),),
                              ),
                          )
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
