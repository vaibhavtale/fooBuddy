import 'package:flutter/material.dart';

showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );

popUpMessage(BuildContext context, String message) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
        ),
      ),
    );
