import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoz_web/model/Marca.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_dropdown.dart';
import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/produto_controller.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:image_picker_web/image_picker_web.dart';

class DialogProduto{
  show(
      BuildContext context,
      ProdutoController controller,
      {Produto? produto}){
      if(produto != null){
        controller.tecId.text = (produto.id??"Gerado automaticamente").toString();
        controller.tecNome.text = produto.nome??"";
        controller.tecPreco.text = UtilBrasilFields.obterReal(produto.preco??0);
        controller.tecDtCriacao.text = FormatingDate.getDate(produto.dataCriacao, FormatingDate.formatDDMMYYYYHHMM);
        controller.tecDtAlteracao.text = FormatingDate.getDate(produto.dataAlteracao, FormatingDate.formatDDMMYYYYHHMM);
        controller.utilizaEstoque = produto.utilizaEstoque??false;
        controller.tecEstoque.text = (produto.estoque??0).toString();
        controller.useCategory = produto.categoria != null ? true : false;
        controller.tecsTamanho = [];
        produto.tamanhos.forEach((element) {
          TextEditingController textEditingController = TextEditingController(text: element.tamanho);
          controller.tecsTamanho.add(textEditingController);
        });
        try{
          controller.categoriaSelected = controller.categorias.where((element) => element.id == produto.categoria?.id).first;
        }catch(e){

        }
        controller.useMarca = produto.marca != null ? true : false;
        try{
          controller.marcaSelected = controller.marcas.where((element) => element.id == produto.marca?.id).first;
        }catch(e){

        }
        controller.isActived = produto.ativo!;
      } else {
        controller.tecId.text = "Gerado automaticamente";
        controller.tecNome.clear();
        controller.tecPreco.clear();
        controller.tecDtCriacao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
        controller.tecDtAlteracao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
        controller.categoriaSelected = null;
        controller.useCategory = false;
        controller.utilizaEstoque = true;
        controller.tecEstoque.clear();
        controller.isActived = true;
        controller.useMarca = false;
        controller.marcaSelected = null;
        controller.tecsTamanho = [];
      }
    showDialog(context: context, builder: (context) {
      controller.setImage(null);
      // if(produto != null && produto.tamanhos.isNotEmpty){
      //   for(int i = 0; i < produto.tamanhos.length; i++) {
      //     controller.tecsTamanho.add(TextEditingController());
      //     controller.tecsTamanho[i].text = produto.tamanhos[i].tamanho!;
      //   }
      // }
      return Observer(
        builder: (context) {
          return AlertDialog(
            title: Text("Produto"),
            content: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                            child: CustomTextField(tec: controller.tecId, label: "Código", enabled: false)
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: CustomTextField(
                            tec: controller.tecNome,
                            label: "Nome",
                            validator: true,
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      tec: controller.tecPreco,
                      label: "Preço",
                      validator: true,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(casasDecimais: 2, moeda: true),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.utilizaEstoque,
                          onChanged: (value) {
                            controller.setUtilizaEstoque();
                          }),
                        Text("Controla Estoque"),
                        SizedBox(width: 8,),
                        if (controller.utilizaEstoque)
                          Expanded(
                            child: CustomTextField(
                              tec: controller.tecEstoque,
                              label: "Estoque",
                              validator: controller.utilizaEstoque,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: CustomTextField(
                            tec: controller.tecDtCriacao,
                            label: "Dt Criação",
                            enabled: false,
                            validator: false,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: CustomTextField(
                            tec: controller.tecDtAlteracao,
                            label: "Dt Alter.",
                            enabled: false,
                            validator: false,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: controller.isActived,
                              onChanged: (value) {
                                controller.changeActived();
                              },
                            ),
                            Text("Ativo"),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.useCategory,
                          onChanged: (value) {
                            controller.changeUseCategory();
                          },
                        ),
                        Text("Categoria"),
                        SizedBox(width: 8),
                        controller.useCategory
                            ? CustomDropDown(
                          value: controller.categoriaSelected,
                          items:controller.categorias.map((e) {
                            return DropdownMenuItem(
                                value: e,
                                child: Text("${e.nome}")
                            );
                          }).toList(),
                          onChange: (selectedValue) {
                            controller.changeCategory(selectedValue as Categoria);
                          },
                        )
                            : Container(),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.useMarca,
                          onChanged: (value) {
                            controller.changeUseMarca();
                          },
                        ),
                        Text("Marca"),
                        SizedBox(width: 8),
                        controller.useMarca
                            ? CustomDropDown(
                          value: controller.marcaSelected,
                          items:controller.marcas.map((e) {
                            return DropdownMenuItem(
                                value: e,
                                child: Text("${e.nome}")
                            );
                          }).toList(),
                          onChange: (selectedValue) {
                            controller.changeMarca(selectedValue as Marca);
                          },
                        ) : Container(),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        controller.addTecTamanho();
                      },
                      child: Row(
                        children: [
                          Text("Tamanho"),
                          IconButton(
                              onPressed: (){
                                controller.addTecTamanho();
                              },
                              icon: Icon(Icons.add_circle_outline)
                          )
                        ],
                      ),
                    ),
                    for(int i = 0 ; i < controller.tecsTamanho.length; i++)
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                                  tec: controller.tecsTamanho[i],
                                  label: "Tamanho ${i+1}",
                                  validator: true
                              )
                          ),
                          IconButton(
                              onPressed: (){
                                controller.removeTecTamanho(i);
                              },
                              icon: Icon(Icons.remove)
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
                          child: controller.bytesImage != null
                              ? Image.memory(controller.bytesImage!)
                              :  produto?.urlImage != null
                              ? Image.network(produto!.urlImage!)
                              : Column( mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_not_supported_outlined,size: 50),
                                  SizedBox(height: 8,),
                                  Text("Produto sem imagem cadastrada")
                                ],
                              ),
                        ),
                      ),
                    ),
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
                        if(produto != null){
                          await controller.updateProduto(produto);
                          CustomSnackbar(
                              message: "Produto atualizado com sucesso!",
                              backgroundColor: Colors.green,
                              textColor: Colors.white
                          ).show(context);
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
              )
            ],
          );
        }
      );
    },);
  }
}