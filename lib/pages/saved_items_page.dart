import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_list_tile.dart';

import '../components/custom_methods.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? data;

  Future<void> _updateSavedItemsList(
      Map<String, dynamic> data, int index) async {
    final List<dynamic> savedList = data['savedItems'];

    savedList.removeAt(index);

    final userData = {
      'savedItems': savedList,
    };

    try {
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

      await _firestore
          .collection(
            'users',
          )
          .doc(docId)
          .update(userData);
      setState(
        () {},
      );
      showMessage(
        context,
        'Success SavedList has been updated successfully',
      );
    } catch (e) {
      showMessage(
        context,
        "Error updating savedList: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Saved Items',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.lime[200],
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firestore
            .collection(
              'users',
            )
            .where(
              'email',
              isEqualTo: _auth.currentUser!.email,
            )
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              data = snapshot.data!.docs.first.data();
              final id = snapshot.data!.docs.first.id;
              List listOfSavedItems = data!['savedItems'];
              return listOfSavedItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: listOfSavedItems.length,
                      itemBuilder: (context, index) {
                        return CustomListTile(
                          data: data!,
                          index: index,
                          onTap: _updateSavedItemsList,
                          id: id,
                          fromSavedPage: true,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No saved Items.",
                      ),
                    );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
