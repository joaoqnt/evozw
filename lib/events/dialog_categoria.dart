import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/categoria_controller.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';

class DialogCategoria{
  show(BuildContext context, CategoriaController controller,{Categoria? categoria}){
    if(categoria != null){
      controller.cTecId.text = (categoria.id??"Gerado automaticamente").toString();
      controller.cTecNome.text = categoria.nome!;
      controller.isActived = categoria.ativo!;
    } else {
      controller.cTecId.text = "Gerado automaticamente";
      controller.cTecNome.clear();
      controller.isActived = true;
    }
    showDialog(context: context, builder: (context) {
      return Observer(
          builder: (context) {
            return AlertDialog(
              title: Text("Categoria"),
              content: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            CustomTextField(tec: controller.cTecId,label: "Código",enabled: false),
                            CustomTextField(
                              tec: controller.cTecNome,
                              label: "Descrição",
                              validator: true,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: controller.isActived,
                                  onChanged: (value) {
                                    controller.changeActived();
                                  },
                                ),
                                Text("Ativo")
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")
                    ),
                    controller.isLoading ? CircularProgressIndicator() : TextButton(
                        onPressed: () async{
                          if(controller.formKey.currentState!.validate()){
                            if(categoria != null){
                              await controller.updateCategorias(categoria);
                              CustomSnackbar(
                                  message: "Categoria atualizada com sucesso!",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white
                              ).show(context);
                            } else{
                              await controller.insertCategorias();
                              CustomSnackbar(
                                  message: "Categoria inserida com sucesso!",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white
                              ).show(context);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Salvar")
                    )
                  ],
                )
              ],
            );
          }
      );
    },);
  }
}