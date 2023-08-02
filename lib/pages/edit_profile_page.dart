import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custom_gradient_text.dart';
import '../components/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _updateUserData(
      String userId,
      TextEditingController nameController,
      TextEditingController addressController,
      TextEditingController emailController,
      TextEditingController phoneController,
      ) async {
    final userData = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'email': emailController.text.trim(),
      'phone_number': phoneController.text.trim(),
    };

    try {
      // Update the Firestore document
      await _firestore.collection('users').doc(userId).update(userData);

      // Print a success message
      print('User data updated successfully.');
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating user data: $e');
    }
  }


  @override
  void dispose(){

    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _adressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firestore
            .collection('users')
            .where('email', isEqualTo: _auth.currentUser!.email)
            .get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){

            if(snapshot.data != null){

              final data = snapshot.data!.docs.first.data();
              final userId = snapshot.data!.docs.first.id;

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      CustomGradientText(text: "Edit Profile"),
                      SizedBox(
                        height: 30,
                      ),

                      CustomTextField(text: "name", textController: _nameController),
                      CustomTextField(text: "address", textController: _adressController),
                      CustomTextField(text: "email", textController: _emailController),
                      CustomTextField(text: "phone number", textController: _phoneController),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () => _updateUserData(
                          userId,
                          _nameController,
                          _adressController,
                          _emailController,
                          _phoneController,
                        ),
                        child: CustomCreateButton(text: "Apply Changes"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: CustomCreateButton(text: "Cancel", gradient: true,),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
            return Center(child: CircularProgressIndicator());

        }
      ),
    );
  }
}



