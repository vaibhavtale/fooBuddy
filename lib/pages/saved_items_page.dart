import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/custom_methods.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _updateSavedItemsList(Map<String, dynamic> data, int index) async {
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
      print("mission succesful boss");
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
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Image.asset(
                                      data['savedItems'][index]['image_url']),
                                  title:
                                      Text(data['savedItems'][index]['name']),
                                  subtitle: Text(
                                    "\$ " +
                                        data['savedItems'][index]['price']
                                            .toString(),
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.redAccent,
                                    onPressed: () async {
                                      await _updateSavedItemsList(data, index);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: Text("No saved Items."));
              } else if(snapshot.hasError){
                return Center(
                  child: Text("please LogIn to Save."),
                );
              }
            }else if(snapshot.hasError){
              return Center(
                child: Text("please LogIn to Save."),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
