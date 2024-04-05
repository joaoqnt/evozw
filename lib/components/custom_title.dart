import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final Widget? widget;

  CustomTitle({
    required this.title,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          if (widget != null) widget!,
        ],
      ),
    );
  }
}
