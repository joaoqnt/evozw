import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/pagamento_controller.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:evoz_web/util/FormatDate.dart';

class DialogForma{
  show(BuildContext context, PagamentoController controller, {FormaPagamento? forma}){
    if(forma != null){
      controller.tecId.text = (forma.id??"Gerado automaticamente").toString();
      controller.tecDescricao.text = forma.descricao??"";
      controller.tecValorMinimo.text = UtilBrasilFields.obterReal(forma.valorMin??0);
      controller.tecDtCriacao.text = FormatingDate.getDate(forma.dataCriacao, FormatingDate.formatDDMMYYYYHHMM);
      controller.tecDtAlteracao.text = FormatingDate.getDate(forma.dataAlteracao, FormatingDate.formatDDMMYYYYHHMM);
      controller.ativo = forma.ativo!;
    } else {
      controller.tecId.text = "Gerado automaticamente";
      controller.tecDescricao.clear();
      controller.tecDescricao.clear();
      controller.tecDtCriacao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
      controller.tecDtAlteracao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
      controller.ativo = true;
    }
    showDialog(context: context, builder: (context) {
      return Observer(
        builder: (context) {
          return AlertDialog(
            title: Text("Forma de Pagamento"),
            content: SingleChildScrollView(
              child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(tec: controller.tecId, label: "Código"),
                      CustomTextField(tec: controller.tecDescricao, label: "Descricao",validator: true),
                      Row(
                        children: [
                          Checkbox(
                              value: controller.utilizaValMin,
                              onChanged: (value) {
                                controller.setUtilizaValMin();
                              }),
                          Text("Utiliza Valor Minimo")
                        ],
                      ),
                      controller.utilizaValMin ?
                      CustomTextField(
                        tec: controller.tecValorMinimo,
                        label: "Valor Mínimo",
                        validator: controller.utilizaValMin
                      )
                          : Container(),
                      CustomTextField(tec: controller.tecDtCriacao, label: "Data de Criação",enabled: false),
                      CustomTextField(tec: controller.tecDtAlteracao, label: "Data de Alteração",enabled: false),
                      Row(
                        children: [
                          Checkbox(
                              value: controller.ativo,
                              onChanged: (value) {
                                controller.setAtivo();
                              }),
                          Text("Ativo")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
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
                                  if(forma != null){
                                    // await controller.updateProduto(produto);
                                    // CustomSnackbar(
                                    //     message: "Produto atualizado com sucesso!",
                                    //     backgroundColor: Colors.green,
                                    //     textColor: Colors.white
                                    // ).show(context);
                                  } else {
                                    await controller.insertProduto();
                                    CustomSnackbar(
                                        message: "Produto inserido com sucesso!",
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white
                                    ).show(context);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Salvar"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          );
        }
      );
    },);
  }
}