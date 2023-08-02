import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_card.dart';

import '../components/menu_style.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({Key? key}) : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  String searchQuery = '';

  List<MenuCard> filteredMenuList() {
    if (searchQuery.isEmpty) {
      return [];
    } else {
      return menuList
          .where((menu) =>
              menu.foodName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
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
                      const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          style: TextStyle(fontSize: 20, color: Colors.black),
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
            Expanded(
              child: ListView.builder(
                itemCount: filteredMenuList().length,
                itemBuilder: (context, index) {
                  MenuCard menuCard = filteredMenuList()[index];
                  return MyMenuStyle(
                    menuCard: menuCard,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
