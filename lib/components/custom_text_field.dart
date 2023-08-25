import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final Icon? prefixIcon;
  final TextEditingController textController;
  final bool? obscure;

  const CustomTextField(
      {Key? key,
      required this.text,
      required this.textController,
      this.obscure,
      this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dist = MediaQuery.of(context).size.width * 0.18;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dist,
        vertical: 5,
      ),
      child: TextField(
        obscureText: obscure == true ? true : false,
        controller: textController,
        decoration: InputDecoration(
          // hintText: text,
          labelText: text,
          hintStyle: const TextStyle(
            fontSize: 15,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
