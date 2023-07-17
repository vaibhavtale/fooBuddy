import 'package:flutter/material.dart';
import 'package:foodbuddy/components/menu_card.dart';

class MenuItemPage extends StatefulWidget {
  final MenuCard menuCard;

  const MenuItemPage({Key? key, required this.menuCard}) : super(key: key);

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(colors: [Colors.red, Colors.pink]),
              ),
              child: Image.asset(
                widget.menuCard.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    widget.menuCard.foodName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text("\$" + widget.menuCard.price.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red)),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 150, right: 50),
                  child: Text(
                    "Quantity : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                ),
                Text(
                  "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text("1"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "+",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)
                    ),
                    width: 70,
                    height: 60,
                    child: Icon(
                      Icons.add_task,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => addItemToCart(widget.menuCard),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    width: 300,
                    height: 60,
                    child: Center(
                      child: Text("Add To Cart", style: TextStyle(fontSize: 22, color: Colors.white),),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
