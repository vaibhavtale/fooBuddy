import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/menu_item_page.dart';

class MyMenuStyle extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  final bool? fromSearchPage;

  const MyMenuStyle({
    Key? key,
    required this.data,
    this.fromSearchPage,
    required this.id,
  }) : super(
          key: key,
        );

  @override
  State<MyMenuStyle> createState() => _MyMenuStyleState();
}

class _MyMenuStyleState extends State<MyMenuStyle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MenuItemPage(
                data: widget.data,
                id: widget.id,
              ),
            ),
          );
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
              ),
              height: MediaQuery.of(context).size.height * 0.23,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: Image.network(
                  widget.data['image_url'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: 350,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    10,
                  ),
                  bottomLeft: Radius.circular(
                    10,
                  ),
                ),
                color: Colors.white60,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      widget.data['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      "\$${widget.data['price']}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (widget.fromSearchPage == true)
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 130,
                  right: 140,
                ),
                // height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Text(
                    widget.data['hotel_name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
