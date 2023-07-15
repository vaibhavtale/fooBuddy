import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/pages/register_page.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _resetPasswordController = TextEditingController();

  Future<User?> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passWordController.text.trim(),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Please enter valid credentials."),
        ),
      );
    }
    return null;
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _resetPasswordController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _emailController.dispose();
    _resetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              "Hey Buddy",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              colors: [Colors.orangeAccent, Colors.redAccent],
            ),
            SizedBox(
              height: 25,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "log in",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "celebrate the foodie in you.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email...",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password...",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
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
              onTap: () => signIn(),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Colors.orangeAccent,
                      Colors.deepOrangeAccent,
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  child: Text(
                    "Login",
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
            GestureDetector(
              onTap: () {
                _resetPasswordController.clear();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Email will be sent with a \nlink please follow that to \nreset password.",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _resetPasswordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "cancel",
                        ),
                      ),
                      TextButton(
                          onPressed: () => resetPassword(),
                          child: Text("send link"))
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300]),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage())),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  child: Text(
                    "Create New Account",
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
    );
  }
}
