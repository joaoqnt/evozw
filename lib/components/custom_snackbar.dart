import 'package:flutter/material.dart';

class CustomSnackbar {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  CustomSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.duration = const Duration(seconds: 2)
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
