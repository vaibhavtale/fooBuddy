import 'package:flutter/material.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.safety_check),
    );
  }
}
