import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({Key? key}) : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
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
                      Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: InputDecoration(
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
                child: Center(
              child: GradientText(
                "Search the Food here",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                colors: [Colors.red, Colors.orange],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
