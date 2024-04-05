import 'package:evoz_web/components/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_vendas.dart';
import 'package:evoz_web/controller/balcao_controller.dart';

class DialogComanda{
  show(BuildContext context, BalcaoController controller){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Comandas"),
        content: SingleChildScrollView(
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  CustomTextField(
                      tec: controller.tecPesquisaComanda,
                      label: "Pesquisar",
                      suffixIcon: Icon(Icons.search),
                      onChanged: (){
                        controller.filterComandas();
                      }
                  ),
                  SizedBox(height: 8),
                  for(int i =0; i < controller.vendasComandaFiltered.length; i++)
                    Row(
                      children: [
                        Expanded(child: CardVendas(venda: controller.vendasComandaFiltered[i])),
                        IconButton(
                            onPressed: (){
                              controller.setVenda(controller.vendasComandaFiltered[i]);
                              // print(controller.vendasComanda[i].itens.length);
                            },
                            icon: Icon(Icons.remove_red_eye_outlined)
                        )
                      ],
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