import 'dart:typed_data';

import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/marca_controller.dart';
import 'package:evoz_web/model/Marca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker_web/image_picker_web.dart';

class DialogMarca{
  show(BuildContext context, MarcaController controller, {Marca? marca}){
    if(marca != null){
      controller.tecNome.text = marca.nome!;
      controller.tecId.text = marca.id.toString();
    } else {
      controller.tecNome.text = '';
      controller.tecId.text = '';
    }
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Marca"),
        content: Observer(
          builder: (context) {
            return Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 100,
                            child: CustomTextField(
                              tec: controller.tecId,
                              label: "Código",
                              enabled: false,
                              validator: false)
                        ),
                        SizedBox(width: 8),
                        Expanded(
                            child: CustomTextField(
                                tec: controller.tecNome,
                                label: "Nome")
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async{
                        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
                        if(bytesFromPicker != null){
                          controller.setImage(bytesFromPicker);
                        }
                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: 250,
                          height: 250,
                          child: controller.bytesImageLogo != null
                              ? Image.memory(controller.bytesImageLogo!)
                              :  marca?.urlLogo != null
                              ? Image.network(marca!.urlLogo!)
                              : Column( mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image_not_supported_outlined,size: 50),
                              SizedBox(height: 8,),
                              Text("Marca sem imagem cadastrada")
                            ],
                          ),
                        ),
                      ),
                    ),
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
                              if(marca != null){
                                await controller.updateMarca(marca);
                                CustomSnackbar(
                                    message: "Marca atualizada com sucesso!",
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white
                                ).show(context);
                              } else {
                                await controller.createMarca();
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
                    )
                  ],
                ),
              ),
            );
          }
        ),
      );
    });
  }
}