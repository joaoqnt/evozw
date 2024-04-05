import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/venda_controller.dart';
import 'package:evoz_web/model/Venda.dart';

class DialogShowVenda{
  show(BuildContext context, Venda venda, VendaController controller){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Venda"),
        content: Observer(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      _containerPage("Venda", 0, controller,context),
                      _containerPage("Itens", 1, controller,context),
                    ],
                  ),
                  Divider(),
                  controller.pageSelected == 0 ? _pageVenda(controller,venda,context) : _pageItens(venda)
                ],
              ),
            );
          }
        ),
      );
    },);
  }

  Widget _containerPage(String page, int pageIndex, VendaController controller, BuildContext context){
    return InkWell(
      onTap: () {
        controller.setPage(pageIndex);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        // color: pageIndex == controller.pageSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
        child: Text(page, style: TextStyle(fontWeight: pageIndex == controller.pageSelected ? FontWeight.bold : null)),
      ),
    );
  }

  Widget _pageVenda(VendaController controller, Venda venda, BuildContext context){
    controller.tecNomCli.text = venda.cliente??'Cliente não informado';
    controller.tecValBru.text = UtilBrasilFields.obterReal(venda.valorBruto!);
    controller.tecValLiq.text = UtilBrasilFields.obterReal(venda.valorLiquido!);
    controller.tecValDes.text = UtilBrasilFields.obterReal(venda.desconto??0);
    controller.tecValTroco.text = UtilBrasilFields.obterReal(venda.valorTroco??0);
    return Column(
      children: [
        CustomTextField(
          tec: controller.tecValBru,
          label: "Valor Bruto",
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            CentavosInputFormatter(casasDecimais: 2,moeda: true)
          ]
        ),
        CustomTextField(
            tec: controller.tecValLiq,
            label: "Valor Líquido",
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2,moeda: true)
            ]
        ),
        CustomTextField(
            tec: controller.tecValDes,
            label: "Valor Desconto",
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2,moeda: true)
            ]
        ),
        (venda.valorTroco??0) > 0 ? CustomTextField(
            tec: controller.tecValTroco,
            label: "Valor Troco",
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2,moeda: true)
            ]
        ) : Container(),
        CustomTextField(tec: controller.tecNomCli, label: "Cliente"),
        SizedBox(height: 8,),
        for(int i = 0; i < venda.pagamentos.length; i++)
          Row(
            children: [
              Text("${venda.pagamentos[i].pagamento} : ",style: TextStyle(fontWeight: FontWeight.bold),),
              Text(UtilBrasilFields.obterReal(venda.pagamentos[i].valor??0))
            ],
          )
      ],
    );
  }

  Widget _pageItens(Venda venda){
    return Column(
      children: [
        for(int i = 0; i < venda.itens.length; i++)
          Row(
            children: [
              Expanded(child: Text("${venda.itens[i].quantidade} ${venda.itens[i].nomeProduto}")),
              Text(UtilBrasilFields.obterReal(venda.itens[i].preco!))
            ],
          )
      ],
    );
  }
}