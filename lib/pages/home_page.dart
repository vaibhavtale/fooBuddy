import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';

import '../components/hotel_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  final int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const CustomGradientText(
            text: "FoodBuddy Online",
          ),
          elevation: 1,
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('hotels').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final hotelDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: hotelDocs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = hotelDocs[index].data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: HotelStyle(
                      data: data,
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )

        // bottomNavigationBar: MyNavigationBar(),
        );
  }
}
