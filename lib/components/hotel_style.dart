import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/menu_page.dart';

class HotelStyle extends StatefulWidget {
  final Map<String, dynamic>? data;

  const HotelStyle({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<HotelStyle> createState() => _HotelStyleState();
}

class _HotelStyleState extends State<HotelStyle> {
  bool _showPlaceholder = true;

  @override
  void initState() {
    // Delay showing the hotel image by 2 seconds
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () {
        if (mounted) {
          setState(
            () {
              _showPlaceholder = false;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MenuPage(
              data: widget.data,
            ),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
              ),
              height: MediaQuery.of(context).size.height * 0.23,
              width: 430,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  12,
                ),
                child: _showPlaceholder
                    ? Image.asset(
                        'images/delivery_boy.png',
                      )
                    : Image.network(
                        widget.data!['image_url'],
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: 430,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    12,
                  ),
                  bottomLeft: Radius.circular(
                    12,
                  ),
                ),
                color: Colors.black45,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.data!['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.data!['non_veg'] == true
                          ? const Text(
                              "Non-Veg",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(''),
                      const SizedBox(
                        width: 10,
                      ),
                      widget.data!['non_veg'] == true
                          ? const Text(
                              "Veg",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              "Pure Veg",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
