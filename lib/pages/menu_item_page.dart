import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';

class MenuItemPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const MenuItemPage({
    Key? key,
    required this.data,
    required this.id,
  }) : super(
          key: key,
        );

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _itemCount = 1;

  Future<void> _addItemToUserCart() async {
    // Add the item to the userCart list
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'hotel_name': widget.data['hotel_name'],
      'item_count': _itemCount,
      'product_id': widget.id,
      'other_charges': widget.data['other_charges'],
    };

    final docs = await _firestore
        .collection('users')
        .where(
          'email',
          isEqualTo: _auth.currentUser!.email,
        )
        .get();

    final docId = docs.docs.first.id;
    List<dynamic> userCartList = docs.docs.first['userCart'];

    int existIndex = userCartList.indexWhere(
      (item) => item['name'] == itemData['name'],
    );

    int otherHotelProduct = userCartList.indexWhere(
      (item) => item['hotel_name'] != itemData['hotel_name'],
    );

    if (otherHotelProduct != -1) {
      showMessage(
        context,
        "Can't add product from multiple Hotels, Clear your existing Cart.",
      );
      return;
    }

    if (existIndex == -1) {
      userCartList.add(itemData);
    } else {
      userCartList[existIndex]['item_count'] = _itemCount;
    }

    try {
      await _firestore.collection('users').doc(docId).update(
        {
          'userCart': userCartList,
        },
      );
      showMessage(
        context,
        'successfully added item to user cart',
      );
    } catch (e) {
      showMessage(
        context,
        'failed to add item',
      );
    }
  }

  void _incrementCounter(bool increment) {
    increment ? _itemCount++ : _itemCount--;
  }

  Future<void> _addItemToSavedList() async {
    Map<String, dynamic> itemData = {
      'name': widget.data['name'],
      'image_url': widget.data['image_url'],
      'price': widget.data['price'],
      'item_count': _itemCount,
      'hotel_name': widget.data['hotel_name'],
    };

    final docs = await _firestore
        .collection(
          'users',
        )
        .where(
          'email',
          isEqualTo: _auth.currentUser!.email,
        )
        .get();

    final docId = docs.docs.first.id;
    List<dynamic> savedItems = docs.docs.first['savedItems'];

    int existIndex = savedItems.indexWhere(
      (item) => item['name'] == itemData['name'],
    );

    if (existIndex == -1) {
      savedItems.add(itemData);
    } else {
      savedItems[existIndex]['item_count'] = _itemCount;
    }

    try {
      await _firestore
          .collection(
            'users',
          )
          .doc(
            docId,
          )
          .update({
        'savedItems': savedItems,
      });
      showMessage(
        context,
        'Product added to savedList successfully.',
      );
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        actions: [
          Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue[200],
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: IconButton(
                onPressed: _addItemToSavedList,
                icon: const Icon(
                  Icons.add_task_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white60.withOpacity(
                      0.5,
                    ), // Shadow color
                    spreadRadius: 5, // How much the shadow spreads
                    blurRadius: 12, // How blurry the shadow is
                    offset: const Offset(
                      0,
                      3,
                    ),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              width: 300,
              height: 300,
              child: Image.asset(
                'images/paneer_masala.png',
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.data['name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            '\$${widget.data['price']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.data['hotel_name'],
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            '(open)',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text('close at,'),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 90,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              color: Colors.deepOrange,
                            ),
                            child: const Center(
                              child: Text(
                                '10:00 PM',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 3,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomContainer(
                            title: '20 min',
                            subTitle: 'delivery time',
                            icon: Icon(
                              Icons.timer_outlined,
                              color: Colors.white,
                            ),
                          ),
                          CustomContainer(
                            title: '3 km',
                            subTitle: 'distance',
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                          CustomContainer(
                            title: '4.5',
                            subTitle: '83 reviews',
                            icon: Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Food details',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'this is an traditional dish from the jaipur beltway, it is a mushroom based scrumptious and unique combination of wholesome.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: _addItemToUserCart,
                        child: const CustomNonGradientButton(
                          text: 'Add to cart',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final Icon icon;
  const CustomContainer(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Center(
            child: icon,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
