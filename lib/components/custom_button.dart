import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onTap;
  final IconData? icon;
  final bool loading;

  const CustomBtn(
      {super.key,
      required this.text,
      required this.onTap,
      this.icon,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 300,
        height: 50,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.pinkAccent, Colors.orangeAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: Colors.white,
                    )
                ],
              ),
      ),
    );
  }
}


