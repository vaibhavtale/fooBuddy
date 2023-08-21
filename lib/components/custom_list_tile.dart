import 'package:flutter/material.dart';

import '../pages/menu_item_page.dart';

class CustomListTile extends StatefulWidget {
  final String id;
  final bool fromSavedPage;
  final Map<String, dynamic> data;
  final int index;
  final Function onTap;
  const CustomListTile(
      {super.key,
      required this.data,
      required this.index,
      required this.onTap,
      required this.id,
      required this.fromSavedPage});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 35,
        right: 35,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.5,
            ), // Shadow color
            spreadRadius: 5, // How much the shadow spreads
            blurRadius: 10, // How blurry the shadow is
            offset: const Offset(
              0,
              3,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 25,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MenuItemPage(
                      data: !widget.fromSavedPage
                          ? widget.data['userCart'][widget.index]
                          : widget.data['savedItems'][widget.index],
                      id: widget.id,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          !widget.fromSavedPage
                              ? widget.data['userCart'][widget.index]
                                  ['image_url']
                              : widget.data['savedItems'][widget.index]
                                  ['image_url'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        !widget.fromSavedPage
                            ? widget.data['userCart'][widget.index]['name']
                            : widget.data['savedItems'][widget.index]['name'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        !widget.fromSavedPage
                            ? 'Item - ${widget.data['userCart'][widget.index]['item_count']}'
                            : 'Item - ${widget.data['savedItems'][widget.index]['item_count']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        !widget.fromSavedPage
                            ? 'Price - \$${widget.data['userCart'][widget.index]['price']}'
                            : 'Price - \$${widget.data['savedItems'][widget.index]['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await widget.onTap(widget.data, widget.index);
                setState(() {});
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.pinkAccent,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
