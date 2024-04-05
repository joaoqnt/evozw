import 'package:evoz_web/components/circle_number.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_produto.dart';
import 'package:evoz_web/components/custom_btnOptions.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/produto_controller.dart';
import 'package:evoz_web/events/dialog_confirm.dart';
import 'package:evoz_web/events/dialog_produto.dart';
import 'package:evoz_web/model/Produto.dart';

class ProdutoPageView extends StatelessWidget {
  final controller = ProdutoController();

  ProdutoPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
          onPressed: (){
            DialogProduto().show(context, controller);
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return Column(
                children: [
                  CustomTitle(
                    title: "Produtos",
                    widget: CircleNumber(controller.produtosFiltered.length)
                    // Container(
                    //   decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Theme.of(context).colorScheme.primaryContainer
                    //   ),
                    //   padding: EdgeInsets.all(8),
                    //   child: Text("${controller.qtdProdutos}"),
                    // )
                  ),
                  Divider(),
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        CustomButtonOptions(0,controller.buttonSelected,"Todos",()=>controller.setButtonCategory(0)),
                        SizedBox(width: 8,),
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.categorias.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    CustomButtonOptions(
                                        controller.categorias[index].id!,
                                        controller.buttonSelected,
                                        controller.categorias[index].nome!,
                                        ()=> controller.setButtonCategory(controller.categorias[index].id!)
                                    ),
                                    SizedBox(width: 8,)
                                  ],
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                      tec: controller.tecPesquisa,
                      label: "Pesquisar",
                      hint: "Pesquise aqui o produto",
                      border: OutlineInputBorder(),
                      onChanged: (){
                        controller.filterProdutosByDescricao();
                      },
                      suffixIcon: Icon(Icons.search)
                  ),
                  SizedBox(height: 8)
                ],
              );
            }
          ),
          FutureBuilder(
            future: controller.getAll(),
            builder: (context, snapshot) {
              return Expanded(
                child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                  builder: (context) {
                    return ListView.builder(
                      itemCount: controller.produtosFiltered.length,
                      itemBuilder: (context, index) {
                        return CardProduto(
                          controller.produtosFiltered[index],
                          icone: Icon(Icons.delete_forever_outlined,color: Colors.red,),
                          functionIcone: () {
                            DialogConfirm().show(
                                context,
                                "Excluir o produto",
                                controller.isLoading,
                                () async{
                                  await controller.deleteProduto(controller.produtosFiltered[index]);
                                });
                            },
                          functionOntap: () {
                            DialogProduto().show(
                              context,
                              controller,
                              produto: controller.produtosFiltered[index],
                            );
                            });}
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
