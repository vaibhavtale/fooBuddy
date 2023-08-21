import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/custom_text_field.dart';
import 'package:foodbuddy/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<User?> createUser() async {
    String phoneNumber = _phoneController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );
    if (phoneNumber.length != 10) {
      showMessage(
        context,
        'please Enter correct 10-digit phone Number.',
      );
    } else if (_nameController.text.isEmpty) {
      showMessage(
        context,
        'please Enter your name.',
      );
    } else if (_addressController.text.isEmpty) {
      showMessage(
        context,
        'please Enter your current address.',
      );
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passWordController.text.trim(),
        );

        await addUserDetails();

        Navigator.of(context).pop(
          MaterialPageRoute(
            builder: (context) => const AuthCheck(),
          ),
        );
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'weak-password') {
            showMessage(
              context,
              'The password provided is too weak.',
            );
          } else if (e.code == 'email-already-in-use') {
            showMessage(
              context,
              'The account already exists for that email.',
            );
          } else if (e.code == 'invalid-email') {
            showMessage(
              context,
              'Please enter a valid email address.',
            );
          } else {
            showMessage(
              context,
              'An error occurred while registering.',
            );
          }
        } else {
          showMessage(
            context,
            'An error occurred while registering.',
          );
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future addUserDetails() async {
    final customUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection(
          'users',
        )
        .doc(customUID)
        .set(
      {
        "email": _emailController.text.trim(),
        "phone_number": _phoneController.text.trim(),
        "name": _nameController.text.trim(),
        "address": _addressController.text.trim(),
        "userCart": [],
        "savedItems": [],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomGradientText(
                text: "Welcome Buddy",
              ),
              const Center(
                child: Text(
                  "Create A New Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                text: "name",
                textController: _nameController,
              ),
              CustomTextField(
                text: "address",
                textController: _addressController,
              ),
              CustomTextField(
                text: "email",
                textController: _emailController,
              ),
              CustomTextField(
                text: "phone number",
                textController: _phoneController,
              ),
              CustomTextField(
                text: "password",
                textController: _passWordController,
                obscure: true,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => createUser(),
                child: const CustomGradientButton(
                  text: "SignUp",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const CustomGradientButton(
                  text: "Back To Login",
                  gradient: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
