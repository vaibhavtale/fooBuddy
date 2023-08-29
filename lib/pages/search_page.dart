import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/menu_style.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  String searchQuery = '';
  final _firestore = FirebaseFirestore.instance;

  late FocusNode searchFocusNode;

  @override
  void initState() {
    searchFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('menu').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> productList =
                  snapshot.data!.docs.map((doc) => doc.data()).toList();
              List<Map<String, dynamic>> filteredMenuList = [];
              for (int i = 0; i < productList.length; i++) {
                if (productList[i]['name'].contains(searchQuery)) {
                  filteredMenuList.add(productList[i]);
                }
              }
              return Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(
                                  () {},
                                ),
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
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pinkAccent,
                                      fontSize: 24,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomContainer(
                            imagepath: 'images/burger1.png',
                            text: 'Burger',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/paneer_masala.png',
                            text: 'Paneer',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/milk_shake.png',
                            text: 'Milk shake',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/hot_dog.png',
                            text: 'Hot dog',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/pizza2.png',
                            text: 'Pizza',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/ice_cream1.png',
                            text: 'Ice cream',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/chicken2.png',
                            text: 'Chicken',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomContainer(
                            imagepath: 'images/biryani1.png',
                            text: 'Biryani',
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                    searchQuery.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: filteredMenuList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> menuData =
                                    filteredMenuList[index];
                                return MyMenuStyle(
                                  fromSearchPage: true,
                                  data: menuData,
                                  id: '',
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: 5,
                          )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String imagepath;
  final String text;
  const CustomContainer(
      {super.key, required this.imagepath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage(imagepath)),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.blueGrey)),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imagepath), fit: BoxFit.contain),
              color: Colors.black26,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 8,
            ),
          )
        ],
      ),
    );
  }
}
