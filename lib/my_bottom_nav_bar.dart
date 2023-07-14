import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/home_page.dart';
import 'package:foodbuddy/pages/profile_page.dart';
import 'package:foodbuddy/pages/saved_items_page.dart';
import 'package:foodbuddy/pages/search_page.dart';

import 'components/hotels.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _currIndex = 0;

  List<Widget> _bottomBar = [
    HomePage(),
    SearchScreenPage(),
    SavedItemsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomBar[_currIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currIndex,
        onTap: (int newIndex) {
          setState(() {
            _currIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_add_check_rounded,
              ),
              label: "Saved"),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.person,
              ),
              label: "Profile")
        ],
      ),
    );
  }
}
