import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/custom_textfield.dart';
import 'package:foodbuddy/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  final bool? fromMenuItemPage;

  LoginPage({Key? key, this.fromMenuItemPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _resetPasswordController =
      TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<User?> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passWordController.text.trim(),
      );
      showMessage(context, 'logged in successfully as ${_emailController.text}');
      widget.fromMenuItemPage != null ? Navigator.of(context).pop() : null;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
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
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 30,
            ),
            const CustomGradientText(
              text: 'Hey Buddy',
            ),
            const SizedBox(
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
            const SizedBox(
              height: 30,
            ),
            CustomTextField(text: "email", textController: _emailController),
            CustomTextField(
              text: "password",
              textController: _passWordController,
              obscure: true,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await signIn();
              },
              child: const CustomGradientButton(text: "Login"),
            ),
            const SizedBox(
              height: 7,
            ),
            GestureDetector(
              onTap: () {
                _resetPasswordController.clear();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
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
                        const Text(
                          "Email will be sent with a \nlink please follow that to \nreset password.",
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _resetPasswordController,
                              decoration: const InputDecoration(
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
                        child: const Text(
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
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage())),
              child: const CustomGradientButton(
                text: 'Create New Account',
                gradient: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
