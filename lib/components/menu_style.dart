import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/menu_item_page.dart';

class MyMenuStyle extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool? fromSearchPage;

  const MyMenuStyle({Key? key, required this.data, this.fromSearchPage})
      : super(key: key);

  @override
  State<MyMenuStyle> createState() => _MyMenuStyleState();
}

class _MyMenuStyleState extends State<MyMenuStyle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          print('-------------------------------------------------------');
          print(widget.data);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MenuItemPage(
                    data: widget.data,
                  ),),);
        },
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Stack(
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
                     widget.data['image_url'],
                     fit: BoxFit.cover,
                   ),),
               ),
               Container(
                 height: MediaQuery.of(context).size.height * 0.08,
                 width: 350,
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(
                         bottomRight: Radius.circular(10),
                         bottomLeft: Radius.circular(10)),
                     color: Colors.white60),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text(
                         widget.data['name'],
                         style: TextStyle(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.black),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text(
                         "\$" + widget.data['price'].toString(),
                         style: TextStyle(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.red),
                       ),
                     )
                   ],
                 ),
               ),
             ],
           ),
                if(widget.fromSearchPage == true) Container(
                  margin: EdgeInsets.only(top: 30),
                // height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white60,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    widget.data['hotel_name'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
    ;
  }
}
