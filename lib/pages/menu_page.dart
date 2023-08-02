import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_card.dart';
import 'package:foodbuddy/components/menu_style.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';

  List<MenuCard> filteredMenuList() {
    if (searchQuery.isEmpty) {
      return menuList;
    } else {
      return menuList
          .where((menu) =>
              menu.foodName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView.builder(
            itemCount: filteredMenuList().length,
            itemBuilder: (context, index) {
              MenuCard menuCard = filteredMenuList()[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyMenuStyle(menuCard: menuCard),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration:
                                InputDecoration(border: InputBorder.none),
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
      ),
    );
  }
}
