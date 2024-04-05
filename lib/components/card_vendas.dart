import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/controller/venda_controller.dart';
import 'package:evoz_web/events/dialog_showVenda.dart';
import 'package:evoz_web/model/Venda.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';

class CardVendas extends StatelessWidget{
  final VendaController? controller;
  final Venda venda;

  CardVendas({this.controller, required this.venda});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller != null ? DialogShowVenda().show(context, venda ,controller!) : print(venda.itens.length);
      },
      child: Observer(
        builder: (context) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text("${venda.id}")),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("${FormatingDate.getDate(
                                    venda.dataPedido,
                                    FormatingDate.formatDDMMYYYYHHMM)}"
                                ),
                                SizedBox(width: 8,),
                                venda.comanda == true ? Expanded(
                                  child: Text("Comanda",
                                    style: TextStyle(color: Colors.yellow.shade600,fontWeight: FontWeight.bold)
                                  ),
                                ) : Container()
                              ],
                            ),
                            venda.mesa != 0 ? Row(
                              children: [
                                Text("Mesa: "),
                                Text(venda.mesa.toString()),
                              ],
                            ) : Container(),
                            Row(
                              children: [
                                Text("Valor Líquido: "),
                                Text(
                                    UtilBrasilFields.obterReal(venda.valorLiquido!),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      controller != null ? IconButton(
                          onPressed: (){
                            controller!.setExpanded(venda);
                          },
                          icon: Icon(controller!.mapIsExpanded[venda] == true ? Icons.expand_less : Icons.expand_more)
                      ) : Container()
                    ],
                  ),
                  controller != null ? controller!.mapIsExpanded[venda] == true ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Row(
                        children: [
                          Text("Vendedor: "),
                          Text(venda.usuario!.nome!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Cliente: "),
                          Text(venda.cliente??"Sem cliente informado",
                            style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Valor Bruto: "),
                          Text("${UtilBrasilFields.obterReal(venda.valorBruto??0)}",
                            style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Desconto: "),
                          Text(UtilBrasilFields.obterReal(venda.desconto??0),
                            style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ],
                  ) : Container() : Container()
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}