import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/components/custom_dropdown.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_pagamento.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/balcao_controller.dart';

import '../components/custom_snackbar.dart';

class DialogEndVenda{

  endPedido(BuildContext context, BalcaoController controller){
    controller.itensSelected.isEmpty || (Global().usuario!.permContCaixa == true && controller.currentCaixa?.ativo != true )?
    controller.itensSelected.isEmpty ?
    CustomSnackbar(
        message: "Adicione um Produto",
        backgroundColor: Colors.red,
        textColor: Colors.white
    ).show(context) : CustomSnackbar(
        message: "Não é permitido vendas com o Caixa Fechado",
        backgroundColor: Colors.red,
        textColor: Colors.white
    ).show(context):
    showDialog(context: context, builder: (context) {
      controller.getValorRestante();
      controller.tecDataPedido.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
      return AlertDialog(
        title: const Text("Venda"),
        content: SingleChildScrollView(
          child: Observer(
              builder: (context) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.setComanda();
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text("Comanda",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width <= 650 ? 11 : null
                                              ),)
                                        ),
                                        Checkbox(
                                          value: controller.comanda,
                                          onChanged: (value) {
                                            controller.setComanda();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                                  child: CustomDropDown(
                                    hint: "Mesas",
                                    isExpanded: true,
                                    value: controller.mesaSelected,
                                    items: controller.mesas.map((e) {
                                      return DropdownMenuItem(
                                            value: e,
                                            child: Text("${e.id} - ${e.descricao}")
                                      );
                                    }).toList(),
                                    onChange: (p0) {
                                      controller.setMesa(p0);
                                    },
                                  ),
                                ),
                              ),
                              !controller.comanda ? Column(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CardPagamento(
                                            FormaPagamento(id: 0,descricao: "Cartão de Crédito",utilizaBandeira: true),
                                            Icons.credit_card_outlined,
                                            controller,
                                            controller.tecCredito
                                        ),
                                        CardPagamento(
                                            FormaPagamento(id: 1,descricao: "Cartão de Débito",utilizaBandeira: true),
                                            Icons.credit_card_outlined,
                                            controller,
                                            controller.tecDebito
                                        ),
                                        CardPagamento(
                                            FormaPagamento(id: 2,descricao: "Dinheiro"),
                                            Icons.attach_money,
                                            controller,
                                            controller.tecDinheiro
                                        ),
                                        CardPagamento(
                                            FormaPagamento(id: 3,descricao: "Pix"),
                                            Icons.qr_code_2_outlined,
                                            controller,
                                            controller.tecPix
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ) : Container()
                            ],
                          ),
                        ),
                        VerticalDivider(),
                        controller.comanda ? Container() :Container(
                          child: Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async{
                                          await controller.setDateVenda(context);
                                        },
                                        icon: Icon(Icons.calendar_month)
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                        child: CustomTextField(
                                            tec: controller.tecDataPedido,
                                            label: "Data Venda",
                                            enabled: false
                                        )
                                    )
                                  ],
                                ),
                                CustomTextField(tec: controller.tecTotalBruto, label: "Total Bruto",enabled: false),
                                CustomTextField(tec: controller.tecTotalLiq, label: "Total Líquido", enabled: false),
                                CustomTextField(
                                    tec: controller.tecDesconto,
                                    label: "Total de Desconto",
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      CentavosInputFormatter(casasDecimais: 2, moeda: true),
                                    ],
                                    onChanged: (){
                                      controller.setDesconto();
                                    }
                                ),
                                CustomTextField(tec: controller.tecObsPedido, label: "Observação"),
                                SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Total Recebido: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.grey.shade600,
                                            )
                                        )
                                    ),
                                    Text(UtilBrasilFields.obterReal(controller.valorRecebido),
                                        style: TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Total Restante: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.grey.shade600,
                                            ))
                                    ),
                                    Text(UtilBrasilFields.obterReal(controller.valorRestante),
                                        style: TextStyle(
                                            color: controller.valorRestante > 0 ? Colors.red : null,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Total Troco: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.grey.shade600,
                                            ))
                                    ),
                                    Text(UtilBrasilFields.obterReal(controller.valorTroco),
                                        style: TextStyle(
                                            // color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar")
                          ),
                          TextButton(
                              onPressed: () async{
                                if((controller.valorRestante == 0 || controller.comanda) && !controller.isInserting){
                                  await controller.createVenda();
                                  Navigator.pop(context);
                                }
                              },
                              child: controller.isInserting
                                  ? CircularProgressIndicator()
                                  : Text("Finalizar")
                          )
                        ],
                      ),
                    ),
                    if(controller.valorRestante > 0 && !controller.comanda)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Valor Recebido diferente do Total Líquido",
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      )
                  ],
                );
              }
          ),
        ),
      );
    },);
  }
}