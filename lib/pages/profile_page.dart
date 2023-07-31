import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/orders.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  String? currentUserDocumentId;
  bool isLoading = true;

  Future<void> getCurrentUserDocumentId() async {
    QuerySnapshot snapshot = await usersCollection
        .where('email', isEqualTo: currentUser!.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        currentUserDocumentId = snapshot.docs[0].id;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future signOutUser() async {
    print('Before sign out: ${FirebaseAuth.instance.currentUser}');
    await FirebaseAuth.instance.signOut();
    print('After sign out: ${FirebaseAuth.instance.currentUser}');
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDocumentId();
  }

  // the previous state of the page with scaffold widget is over here.
  /*Scaffold(
        body: isLoading ? Center(child: CircularProgressIndicator(color: Colors.black26,),)
       : StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserDocumentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                GradientText(
                  "Your Profile",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [Colors.orangeAccent, Colors.redAccent],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "celebrate the foodie in you.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(userData['email'])),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(userData['adress']),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        Colors.orangeAccent,
                        Colors.deepOrangeAccent,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      // WE WANT TO DO THE UPDATE USER DATA OPERATION OVER HER
                      child: Text(
                        "Apply Changes",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        Colors.pinkAccent,
                        Colors.orangeAccent,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => signOutUser(),
                      // WE WANT TO DO THE UPDATE USER DATA OPERATION OVER HER
                      child: Text(
                        "LogOut",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // print(currentUser);
          print(snapshot.data);
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
      },
    ));*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUserDocumentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                  "images/img1.jpg",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userData['first_name'],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("recent orders"),
                              Text(
                                "view all",
                                style: TextStyle(color: Colors.blue),
                              ),

                            ],
                          ),
                          Column(
                            children: [
                              /*ListView.builder(
                                itemCount: OrderList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ListTile(
                                      title: Text(OrderList[index].itemName),
                                      trailing: Text(OrderList[index].price.toString()),
                                    ),
                                  );
                                },
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  print(snapshot.error.toString());
                  return Center(
                    child: Text("error occured"),
                  );
                }
              },
            ),
    );
  }
}
