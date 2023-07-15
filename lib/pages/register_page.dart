import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/profile_page.dart';
import 'package:foodbuddy/pages/toggle_page.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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

      addUserDetails(
        _emailController.text.trim(),
        int.parse(_phoneController.text.trim()),
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
      String email, int phone, String adress, String name) async {
    await FirebaseFirestore.instance.collection('users').add(
        {"email": email, "phone": phone, "first_name": name, "adress": adress});
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
              GradientText(
                "Welcome Buddy",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                colors: [Colors.red, Colors.orange],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Create A New Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Name...",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    child: TextField(
                      controller: _adressController,
                      decoration: InputDecoration(
                        hintText: "Adress...",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email...",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: "Phone...",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    child: TextField(
                      controller: _passWordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: ()=> createUser(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.orangeAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 95, vertical: 15),
                    child: Text(
                      "Back To Login",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
