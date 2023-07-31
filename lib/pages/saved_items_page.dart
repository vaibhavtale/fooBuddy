import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_card.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCart.length,
        itemBuilder: (context, index){

        MenuCard menuCard = userCart[index];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListTile(
            leading: Image.asset(menuCard.imagePath),
            title: Text(menuCard.foodName),
            subtitle: Text(menuCard.price.toString()),
          ),
        );
        },);
  }
}
