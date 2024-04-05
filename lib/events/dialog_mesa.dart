import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/mesa_controller.dart';

import '../model/Mesa.dart';

class DialogMesa{
  show(BuildContext context, MesaController controller, {Mesa? mesa}){
    showDialog(context: context, builder: (context) {
      if(mesa != null){
        controller.tecCodigo.text = mesa.id.toString();
        controller.tecDescricao.text = mesa.descricao??'';
        controller.tecValorTotal.text = UtilBrasilFields.obterReal(mesa.valorTotal??0);
        controller.tecDataCriacao.text = FormatingDate.getDate(mesa.dataCriacao, FormatingDate.formatDDMMYYYYHHMM);
        if(FormatingDate.getDate(mesa.ultimaVenda, FormatingDate.formatDDMMYYYY) != '24/04/1966')
          controller.tecUltimaVenda.text = FormatingDate.getDate(mesa.ultimaVenda, FormatingDate.formatDDMMYYYYHHMM);
      } else {
        controller.tecCodigo.text = '';
        controller.tecDescricao.text = '';
        controller.tecValorTotal.text = '0';
        controller.tecDataCriacao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
        controller.tecUltimaVenda.text = '';
      }
      return Observer(
        builder: (context) {
          return AlertDialog(
            title: Text("Mesa"),
            content: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    CustomTextField(
                        tec: controller.tecCodigo,
                        label: "Código",
                        validator: true,
                        enabled: mesa != null ? false : true,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                    CustomTextField(
                      tec: controller.tecDescricao,
                      label: "Descrição",
                      validator: true
                    ),
                    mesa != null ? Column(
                      children: [
                        CustomTextField(
                            tec: controller.tecDataCriacao,
                            label: "Data Criação",
                            enabled: false
                        ),
                        CustomTextField(
                            tec: controller.tecUltimaVenda,
                            label: "Última Venda",
                            enabled: false
                        ),
                        CustomTextField(
                            tec: controller.tecValorTotal,
                            label: "Valor Total",
                            enabled: false
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                  controller.isLoading
                      ? CircularProgressIndicator()
                      : TextButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        if(mesa != null){
                          await controller.updateMesa(mesa);
                        } else{
                          await controller.createMesa();
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Salvar"),
                  ),
                ],
              ),
            ],
          );
        }
      );
    });
  }
}