import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_produto.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/combo_controller.dart';

class ComboAlterPageView extends StatelessWidget {
  final ComboController controller;
  ComboAlterPageView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("EvozW"),
          actions:[
            Observer(
              builder: (context) {
                return controller.isLoading ? CircularProgressIndicator() : IconButton(
                  onPressed: () async{
                    if(controller.formKey.currentState!.validate()) {
                      controller.cabComboSelected != null
                          ? await controller.updateCombo()
                          : await controller.createCombo();
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save)
          );
              }
            )]
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _forms(context),
              SizedBox(height: 8),
              Expanded(
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Produtos",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.produtos.length,
                            itemBuilder: (context, index) {
                              return Observer(
                                builder: (context) {
                                  return CardProduto(
                                      controller.produtos[index],
                                    widget: Column(
                                      children: [
                                        Row(
                                          children: [
                                            controller.isSelected[controller.produtos[index]] == true ?
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          controller.removeProduto(controller.produtos[index]);
                                                        },
                                                        icon: Icon(Icons.remove)
                                                    ),
                                                    Text("${controller.qtdSelected[controller.produtos[index]]}"),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: IconButton(
                                                          onPressed: (){
                                                            controller.addProduto(controller.produtos[index]);
                                                          },
                                                          icon: Icon(Icons.add_outlined)
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ) : Container(),
                                            Checkbox(
                                                value: (controller.isSelected[controller.produtos[index]])??false,
                                                onChanged: (value){
                                                  controller.setProduto(controller.produtos[index]);
                                                }
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _forms(BuildContext context){
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: CustomTextField(
                        tec: controller.tecId,
                        label: "Código",
                        validator: false,
                        enabled: false
                    )
                ),
                SizedBox(width: 8),
                Expanded(
                    child: CustomTextField(
                      tec: controller.tecNome,
                      label: "Descrição",
                    )
                )
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: CustomTextField(tec: controller.tecPreco, label: "Preço Total",enabled: false,)
                ),
                SizedBox(width: 8),
                Expanded(child: CustomTextField(tec: controller.tecDesconto, label: "Desconto Total",validator: false,))
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: CustomTextField(tec: controller.tecDataCriacao, label: "Data Criação",enabled: false,)
                ),
                SizedBox(width: 8),
                Expanded(
                    child: CustomTextField(
                      tec: controller.tecDataAlteracao,
                      label: "Data Alteração",
                      enabled: false,
                    )
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                    value: controller.isActive,
                    onChanged: (value){

                    }
                ),
                Text("Ativo")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
