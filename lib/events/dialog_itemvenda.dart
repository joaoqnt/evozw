import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/components/custom_textfield.dart';

import '../model/ItemVenda.dart';

class DialogItemVenda{
  show(
      ItemVenda item,
      BuildContext context,
      TextEditingController tecProduto,
      TextEditingController tecQuantidade,
      TextEditingController tecPrecoUnitario,
      TextEditingController tecPreco,
      Function changeQtd,
      Function tapButton,
      ){
    // _controller.setItem(item);
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("${item.produto!.nome}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomTextField(tec: tecProduto, label: "Produto"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomTextField(
                    tec: tecQuantidade,
                    label: "Quantidade",
                    onChanged: (){
                      changeQtd();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomTextField(
                    tec: tecPrecoUnitario,
                    label: "Preço Unitário",
                    enabled: false
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomTextField(
                    tec: tecPreco,
                    label: "Preço",
                    enabled: false
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")
              ),
              TextButton(
                  onPressed: (){
                    tapButton();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              ),
            ],
          )
        ],
      );
    },);
  }
}