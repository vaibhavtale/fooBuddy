import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CustomGradientText extends StatelessWidget {
  final String text;

  const CustomGradientText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text,
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      colors: [Colors.red, Colors.orange],
    );
  }
}

// Custom button for user creation, login, create user, update data.....

class CustomGradientButton extends StatelessWidget {
  final String text;
  final bool? gradient;

  const CustomGradientButton({Key? key, required this.text, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient == null
            ? LinearGradient(colors: [
                Colors.orangeAccent,
                Colors.deepOrangeAccent,
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)
            : null,
        border: gradient == true
            ? Border.all(
                color: Colors.black,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: gradient == null ? 80 : 30, vertical: 15),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 25,
              color: gradient == null ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//Button used to add items to cart

class CustomNonGradientButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const CustomNonGradientButton({Key? key, required this.onTap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(15)),
      width: 300,
      height: 60,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomCircularButton extends StatelessWidget {
  final Icon icon;
  const CustomCircularButton({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepOrange
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: icon),
      ),
    );
  }
}


