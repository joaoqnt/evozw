import 'package:flutter/material.dart';

class CircleNumber extends StatelessWidget {
  dynamic value;

  CircleNumber(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      padding: EdgeInsets.all(8),
      child: Text("${value}",style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
    );
  }

}