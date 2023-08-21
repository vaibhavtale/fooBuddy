import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController textController;
  final bool? obscure;

  const CustomTextField(
      {Key? key,
      required this.text,
      required this.textController,
      this.obscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dist = MediaQuery.of(context).size.width * 0.30;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: dist, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: TextField(
          obscureText: obscure == true ? true : false,
          controller: textController,
          decoration: InputDecoration(
            hintText: text,
            hintStyle: const TextStyle(fontSize: 15),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
