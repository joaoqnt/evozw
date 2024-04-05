import 'package:flutter/material.dart';

class ToolTipCustom extends StatelessWidget {
  const ToolTipCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Teste",
    );
  }
}
