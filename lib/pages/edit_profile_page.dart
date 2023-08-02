import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/profile_with_icon.dart';
import 'package:image_picker/image_picker.dart';

import '../components/custom_gradient_text.dart';
import '../components/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  File? image;

  @override
  void initState() {
    _emailController.text = widget.data['email'];
    _nameController.text = widget.data['name'];
    _phoneController.text = widget.data['phone_number'];
    _addressController.text = widget.data['address'];
    super.initState();
  }

  void _updateUserData() async {
    final userData = {
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'email': _emailController.text.trim(),
      'phone_number': _phoneController.text.trim(),
    };

    try {
      // Update the Firestore document
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(userData);

      // Print a success message
      Navigator.of(context).pop();
      showMessage(
          context, 'Success Your profile has been updated successfully');
    } catch (e) {
      showMessage(context, "Error updating profile: $e");
    }
  }

  Future _takePhotoFromGallery(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    try {
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      showMessage(context, "Error picking image: $e");
    }
  }

  _uploadImage() async {
    // TODO: Upload image to Firebase Storage
    // url apply to user data
    // url will be stored in user(folder) -> uil (folder) -> profile(file)
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            const CustomGradientText(text: "Edit Profile"),
            ProfileIconWithName(
                name: _nameController.text,
                imageUrl: image?.path ??
                    'https://cdn.pixabay.com/photo/2023/02/08/02/40/iron-man-7775599_1280.jpg',
                email: widget.data['email'],
                onTap: () => _takePhotoFromGallery(ImageSource.gallery)),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(text: "name", textController: _nameController),
            CustomTextField(
                text: "address", textController: _addressController),
            CustomTextField(text: "email", textController: _emailController),
            CustomTextField(
                text: "phone number", textController: _phoneController),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _updateUserData(),
              child: const CustomCreateButton(text: "Apply Changes"),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CustomCreateButton(text: "Cancel", gradient: true),
            ),
          ],
        ),
      ),
    );
  }
}
