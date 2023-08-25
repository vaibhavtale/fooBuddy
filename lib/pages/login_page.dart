import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbuddy/components/custom_gradient_text.dart';
import 'package:foodbuddy/components/custom_methods.dart';
import 'package:foodbuddy/components/custom_text_field.dart';
import 'package:foodbuddy/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  final bool? fromMenuItemPage;

  const LoginPage({Key? key, this.fromMenuItemPage}) : super(key: key);

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
      showMessage(
        context,
        'logged in successfully as ${_emailController.text}',
      );
      widget.fromMenuItemPage != null ? Navigator.of(context).pop() : null;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            "Please enter valid credentials.",
          ),
        ),
      );
    }
    return null;
  }

  Future resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _resetPasswordController.text.trim(),
    );
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
      backgroundColor: Colors.pink[50],
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Image.network(
          //   'images/login.png',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.12,
                vertical: MediaQuery.of(context).size.height * 0.11,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'images/login.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink[100]!.withOpacity(
                        1,
                      ), // Shadow color
                      spreadRadius: 9, // How much the shadow spreads
                      blurRadius: 15, // How blurry the shadow is
                      offset: const Offset(
                        1,
                        5,
                      ),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      const LogInText(
                        text: 'Sign in',
                      ),
                      const LogInText(
                        text: 'celebrate foodie in you..',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        text: "email",
                        textController: _emailController,
                      ),
                      CustomTextField(
                        text: "password",
                        textController: _passWordController,
                        obscure: true,
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
                                  fontSize: 18,
                                ),
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                  child: const Text(
                                    "send link",
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.22,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await signIn();
                        },
                        child: const CustomGradientButton(
                          text: "Login",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => signInWithGoogle(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.20,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              border: Border.all(
                                color: Colors.blue,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    'Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                        10,
                                      ),
                                      topRight: Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: Icon(
                                      Icons.g_mobiledata_outlined,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        ),
                        child: const CustomGradientButton(
                          text: 'Create New Account',
                          gradient: true,
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Text(
            'made with love in India',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class LogInText extends StatelessWidget {
  final String text;
  const LogInText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
