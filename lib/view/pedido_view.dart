import 'package:flutter/material.dart';

class PedidoView extends StatelessWidget {
  PedidoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("Vendas",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18))),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
