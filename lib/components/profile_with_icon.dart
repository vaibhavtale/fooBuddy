import 'package:flutter/material.dart';

class ProfileIconWithName extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String email;
  final VoidCallback onTap;

  const ProfileIconWithName(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.email,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipOval(
              child: Image.network(imageUrl, height: 100, width: 100, fit: BoxFit.cover,),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton(
                color: Colors.blueAccent,
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: onTap,
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
