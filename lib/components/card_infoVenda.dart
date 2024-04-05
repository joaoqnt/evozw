import 'package:flutter/material.dart';
import 'package:evoz_web/controller/venda_controller.dart';
import 'package:evoz_web/events/dialog_showVenda.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CardInfoVenda extends StatelessWidget{
  final VendaController controller;
  final String title;
  final String value;
  final Color? valueColors;
  final Color borderColors;

  CardInfoVenda(this.controller,this.title,this.value,this.borderColors,{this.valueColors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(title != "Pedidos Pendentes" && title != "Total Vendido"){
          controller.filterVendaByPagamento(title);
        }
      },
      child: Observer(
        builder: (context) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: borderColors,width: 3)
                  )
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(title),
                      controller.mapFilterPagamento[title] == true ? Row(
                        children: [
                          SizedBox(width: 4,),
                          Icon(Icons.done,size: 12),
                        ],
                      ) : Container()
                    ],
                  ),
                  SizedBox(height: 8,),
                  Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: valueColors
                    )
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}