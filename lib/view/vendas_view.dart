import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/components/circle_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_infoVenda.dart';
import 'package:evoz_web/components/card_vendas.dart';
import 'package:evoz_web/components/custom_dropdown.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/venda_controller.dart';
import 'package:evoz_web/util/FormatDate.dart';

class VendaView extends StatelessWidget {
  VendaView({Key? key}) : super(key: key);
  final controller = VendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return Column(
                children: [
                  CustomTitle(
                      title: "Vendas",
                      widget: CircleNumber(
                          controller.vendasFiltered.length
                      )
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                              tec: controller.tecPesquisa,
                              label: "Pesquisar",
                              hint: "Cód. Pedido, Val. Líquido ou Cliente"
                          )
                      ),
                      IconButton(
                          onPressed: () async{
                            await controller.setDateIni(context);
                          },
                          icon: Icon(Icons.calendar_month)
                      ),
                      Text("${controller.dtInicial} - ${controller.dtFinal}")
                    ],
                  ),
                ],
              );
            }
          ),
          SizedBox(height: 8,),
          FutureBuilder(
            future: controller.getVendas(),
            builder: (context, snapshot) {
              return Expanded(
                child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CardInfoVenda(
                                  controller,
                                  "Total Vendido",
                                  UtilBrasilFields.obterReal(controller.valorTotal),
                                  valueColors: Colors.green.shade700,
                                  Colors.teal
                              ),
                              CardInfoVenda(
                                  controller,
                                  "Comandas",
                                  controller.vendasFiltered.where((element) => element.comanda == true).toList().length.toString(),
                                  Colors.yellow
                              ),
                              CardInfoVenda(
                                  controller,
                                  "Cartão De Crédito",
                                  UtilBrasilFields.obterReal(controller.valorCredito),
                                  Colors.red
                              ),
                              CardInfoVenda(
                                  controller,
                                  "Cartão De Débito",
                                  UtilBrasilFields.obterReal(controller.valorDebito),
                                  Colors.orange
                              ),
                              CardInfoVenda(
                                  controller,
                                  "Dinheiro",
                                  UtilBrasilFields.obterReal(controller.valorDinheiro),
                                  Colors.green
                              ),
                              CardInfoVenda(
                                  controller,
                                  "Pix",
                                  UtilBrasilFields.obterReal(controller.valorPix),
                                  Colors.blue
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                              itemCount: controller.vendasFiltered.length,
                              itemBuilder: (context, index) {
                                return CardVendas(controller: controller, venda: controller.vendasFiltered[index]);
                              })
                        ),
                      ],
                    );
                  }
                ),
              );
            },)
        ],
      ),
    );
  }
}
