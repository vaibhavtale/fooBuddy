import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/pages/menu_item_page.dart';
import '../components/custom_methods.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _updateSavedItemsList(
      Map<String, dynamic> data, int index) async {
    final List<dynamic> _savedList = data['savedItems'];

    _savedList.removeAt(index);

    final userData = {
      'savedItems': _savedList,
    };

    try {
      final docs = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .get();

      final docId = docs.docs.first.id;

      await _firestore.collection('users').doc(docId).update(userData);
      showMessage(context, 'Success SavedList has been updated successfully');
    } catch (e) {
      showMessage(context, "Error updating savedList: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Items"),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firestore
            .collection('users')
            .where('email', isEqualTo: _auth.currentUser!.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!.docs.first.data();
              List listOfSavedItems = data['savedItems'];
              return listOfSavedItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: data['savedItems'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 35, right: 35),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 5, // How much the shadow spreads
                                blurRadius: 10, // How blurry the shadow is
                                offset: Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => MenuItemPage(
                                              data: data['savedItems']
                                                  [index]))),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 60,
                                        child: Image.asset(
                                          data['savedItems'][index]
                                              ['image_url'],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['savedItems'][index]['name'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Item - ' +
                                                data['savedItems'][index]
                                                        ['quantity']
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Price - \$' +
                                                data['savedItems'][index]
                                                        ['price']
                                                    .toString(),
                                            style: TextStyle(
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
                                      await _updateSavedItemsList(data, index);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.pinkAccent,
                                      size: 35,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text("No saved Items."));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
