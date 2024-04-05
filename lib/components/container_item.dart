import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/model/ItemVenda.dart';
import 'package:evoz_web/util/Coloration.dart';

class ContainerItem extends StatelessWidget {
  final ItemVenda item;
  final int index;
  final Function onTap;
  final Function fAdd;
  final Function fRem;

  ContainerItem({
    required this.item,
    required this.index,
    required this.onTap,
    required this.fAdd,
    required this.fRem,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? index % 2 != 0 ? Theme.of(context).colorScheme.inversePrimary : Colors.transparent
          : index % 2 != 0 ? Colors.grey.shade200 : Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 3),
        child: InkWell(
          onTap: () {
            onTap();
          },
          // hoverColor: Coloration().ligthBlue,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Text("${item.produto!.nome}"),
              ),
              Expanded(
                flex: 5,
                child: Text("${item.quantidade}"),
              ),
              Expanded(
                flex: 10,
                child: Text(item.observacao ?? "(...)"),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  UtilBrasilFields.obterReal(item.preco!),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        fAdd();
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () {
                        fRem();
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
