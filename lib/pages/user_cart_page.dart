import 'package:flutter/material.dart';

import '../components/menu_card.dart';

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserCart"),
      ),
      body: ListView.builder(
        itemCount: userCartList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(userCartList[index].imagePath),
                  title: Text(userCartList[index].foodName),
                  subtitle: Text(
                    "\$ " + userCartList[index].price.toString(),
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.redAccent,
                      onPressed: () {
                        setState(() {
                          userCartList.remove(userCartList[index]);
                        });
                      },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
