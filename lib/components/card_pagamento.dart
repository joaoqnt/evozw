import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/components/custom_dropdown.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/balcao_controller.dart';

class CardPagamento extends StatelessWidget {
  final FormaPagamento pagamento;
  final IconData icon;
  final BalcaoController controller;
  final TextEditingController tec;

  CardPagamento(this.pagamento, this.icon, this.controller, this.tec);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          controller.setPagamento(pagamento,tec);
          controller.getValorRestante();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  Row(
                    children: [
                      MediaQuery.of(context).size.width >= 650
                          ? Row(
                            children: [
                              Icon(icon,color: Colors.blue,),
                              SizedBox(width: 8,),
                            ],
                          )
                          : Container(),
                      Expanded(
                          child: Text(pagamento.descricao!,style: TextStyle(fontWeight: FontWeight.w500),)
                      ),
                      Checkbox(
                        value: controller.mapPagamento[pagamento.descricao]??false,
                        onChanged: (value) {
                          controller.setPagamento(pagamento,tec);
                          controller.getValorRestante();
                        },
                      )
                    ],
                  ),
                  controller.mapPagamento[pagamento.descricao] == true ? Column(
                    children: [
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                                  tec: tec,
                                  label: "Valor",
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CentavosInputFormatter(casasDecimais: 2,moeda: true)
                                  ],
                                  onChanged: (){
                                    controller.getValorRestante();
                                  }
                              )
                          )
                        ],
                      ),
                      CustomDropDown(
                        hint: "Bandeiras",
                        isExpanded: true,
                        // value: controller.mesaSelected,
                        items: controller.bandeiras.map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  e.keys.first,
                                  SizedBox(width: 8),
                                  Expanded(child: Text("${e.values.first}")),
                                  Checkbox(
                                      value: pagamento.bandeiras.contains(e.values.first),
                                      onChanged: (value){
                                        controller.setBandeira(pagamento, e.values.first);
                                      }
                                  )
                                ],
                              )
                          );
                        }).toList(),
                        onChange: (p0) {
                          // controller.setMesa(p0);
                        },
                      )
                    ],
                  ) : Container(),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}