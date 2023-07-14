import 'package:flutter/material.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({Key? key}) : super(key: key);

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.search),
    );
  }
}
