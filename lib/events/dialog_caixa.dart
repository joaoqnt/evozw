import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/balcao_controller.dart';

class DialogCaixa {

  showCaixa({
    required BuildContext context,
    required BalcaoController controller
  }) {
    controller.setCaixa();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Caixa"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                    tec: controller.tecValorInicial,
                    label: "Valor Inicial",
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(casasDecimais: 2,moeda: true)
                    ],
                  enabled: controller.currentCaixa?.ativo == true ? false : null,
                ),
                controller.currentCaixa?.ativo == true ? CustomTextField(
                  tec: controller.tecValorAtual,
                  label: "Valor Atual",
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(casasDecimais: 2,moeda: true)
                  ],
                  enabled: false ,
                ) : Container(),
                CustomTextField(tec: controller.tecDataInicial, label: "Data Abertura",enabled: false,)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.alterCaixa();
                Navigator.pop(context);
              },
              child: Text(controller.currentCaixa?.ativo == true ? "Fechar" : "Abrir"),
            ),
          ],
        );
      },
    );
  }

}
