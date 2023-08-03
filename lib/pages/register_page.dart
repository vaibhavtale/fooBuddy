import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_textfield.dart';
import 'package:foodbuddy/pages/toggle_page.dart';

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
  final TextEditingController _adressController = TextEditingController();

  Future<User?> createUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passWordController.text.trim(),
      );

      print(_emailController.text.trim());

      await addUserDetails(
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _adressController.text.trim(),
        _nameController.text.trim(),
      );

      Navigator.of(context).pop(
        MaterialPageRoute(
          builder: (context) => TogglePage(),
        ),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Please enter valid email."),
              ));
      print(e);
    }
    return null;
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _adressController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future addUserDetails(
      String email, String phone, String address, String name) async {

    final customUID =  FirebaseAuth.instance.currentUser!.uid;
    print(customUID);
    await FirebaseFirestore.instance.collection('users').doc(customUID).set({
      "email": email,
      "phone_number": phone,
      "name": name,
      "address": address,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 10,
              ),
              CustomGradientText(text: "Welcome Buddy"),
              Center(
                child: Text(
                  "Create A New Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(text: "name", textController: _nameController),
              CustomTextField(
                  text: "address", textController: _adressController),
              CustomTextField(text: "email", textController: _emailController),
              CustomTextField(
                  text: "phone number", textController: _phoneController),
              CustomTextField(
                text: "password",
                textController: _passWordController,
                obscure: true,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => createUser(),
                child: CustomCreateButton(text: "SignUp"),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: CustomCreateButton(
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
