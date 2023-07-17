import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/menu_item_page.dart';
import 'menu_card.dart';

class MyMenuStyle extends StatefulWidget {
  final MenuCard menuCard;
  const MyMenuStyle({Key? key, required this.menuCard}) : super(key: key);

  @override
  State<MyMenuStyle> createState() => _MyMenuStyleState();
}

class _MyMenuStyleState extends State<MyMenuStyle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuItemPage(menuCard: widget.menuCard))),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height * 0.23,
              width: 350,
              decoration: BoxDecoration(
                // color: Colors.red
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.menuCard.imagePath,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: Colors.white60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.menuCard.foodName,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("\$" + widget.menuCard.price.toString(), style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );;
  }
}
