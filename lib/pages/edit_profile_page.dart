import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/profile_with_icon.dart';
import 'package:image_picker/image_picker.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? image;
  String imageUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    _emailController.text = widget.data['email'];
    _nameController.text = widget.data['name'];
    _phoneController.text = widget.data['phone_number'];
    _addressController.text = widget.data['address'];
    super.initState();
  }

  Future<void> _takePhotoFromGallery(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    try {
      setState(() {
        this.image = File(image.path);
      });
    } catch (e) {
      showMessage(context, "Error picking image: $e");
    }
  }

  Future<void> _uploadImage() async {
    if (image == null) return;

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference imagePath = referenceRoot
        .child('user')
        .child(_auth.currentUser!.uid)
        .child('profile_image');

    try {
      await imagePath.putFile(image!);
      imageUrl = await imagePath.getDownloadURL();
    } catch (e) {
      showMessage(context, "Error uploading image: $e");
    }
  }

  Future<void> _updateUserData() async {
    await _uploadImage();
    final userData = {
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'phone_number': _phoneController.text.trim(),
      if (imageUrl != '') 'image_url': imageUrl,
    };

    try {
      // await _firestore
      //     .collection('users')
      //     .doc(_auth.currentUser!.uid)
      //     .update(userData);

      final docs = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .get();

      final docId = docs.docs.first.id;
      print(docId);
      await _firestore.collection('users').doc(docId).update(userData);

      Navigator.of(context).pop();
      showMessage(
          context, 'Success Your profile has been updated successfully');
    } catch (e) {
      showMessage(context, "Error updating profile: $e");
    }
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
            SizedBox(height: 80),
            CustomGradientText(text: "Edit Profile"),
            ProfileIconWithName(
                name: _nameController.text,
                imageUrl: image?.path ??
                    'https://cdn.pixabay.com/photo/2023/02/08/02/40/iron-man-7775599_1280.jpg',
                email: widget.data['email'],
                onTap: () async {
                  if (!_isLoading) {
                    _isLoading = true;
                    await _takePhotoFromGallery(ImageSource.gallery);
                    _isLoading = false;
                  }
                },
                isEditable: true),
            SizedBox(height: 30),
            CustomTextField(text: "name", textController: _nameController),
            CustomTextField(
                text: "address", textController: _addressController),
            CustomTextField(text: "email", textController: _emailController),
            CustomTextField(
                text: "phone number", textController: _phoneController),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                if (!_isLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                  await _updateUserData();
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const CustomGradientButton(text: "Apply Changes"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: CustomGradientButton(text: "Cancel", gradient: true),
            ),
          ],
        ),
      ),
    );
  }
}
