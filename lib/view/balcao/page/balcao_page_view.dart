import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/components/circle_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_produto.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/balcao_controller.dart';
import 'package:evoz_web/components/container_item.dart';
import 'package:evoz_web/events/dialog_caixa.dart';
import 'package:evoz_web/events/dialog_comandas.dart';
import 'package:evoz_web/events/dialog_endVenda.dart';
import 'package:evoz_web/events/dialog_itemvenda.dart';
import 'package:badges/badges.dart' as badges;


class BalcaoPageView extends StatefulWidget {
  const BalcaoPageView({Key? key}) : super(key: key);

  @override
  State<BalcaoPageView> createState() => _BalcaoPageViewState();
}

class _BalcaoPageViewState extends State<BalcaoPageView> {
  BalcaoController controller = BalcaoController();
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return
            MediaQuery.of(context).size.width < 650
              ? _layoutMobile() :
          Row(
            children: [
              _divAddProdutos(),
              _divMain()
            ],
          );
        }
      ),
    );
  }

  _init() async{
    await controller.getAll();
  }

  Widget _divAddProdutos(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: 300,
            padding: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.grey.shade300)
                )
            ),
            child: Column(
              children: [
                CustomTitle(
                    title: "Produtos",
                    widget: CircleNumber(controller.qtdProdutos)
                ),
                // Divider(),
                _listCategories(),
                SizedBox(height: 8,),
                CustomTextField(
                    tec: controller.tecPesquisa,
                    label: "Pesquisar",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  onChanged: (){
                      controller.filterProdutosByDescricao();
                  },
                ),
                SizedBox(height: 2),
                _listProdutos()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _listCategories(){
    return Container(
      height: 40,
      // padding: const EdgeInsets.only(top: 4, bottom: 2, right: 4, left: 4),
      color:Theme.of(context).brightness == Brightness.dark
          ? Color.fromRGBO(44, 41, 51, 1.0)
          : Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categorias.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Observer(
                  builder: (context) {
                    return Row(
                      children: [
                        index == 0 ?
                        InkWell(
                            child: Text("Todos",
                                style:  TextStyle(
                                    fontWeight: controller.todosSelected
                                        ? FontWeight.w700
                                        : null,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer
                                )
                            ),
                            onTap: () {
                              controller.setTodos(true);
                            }
                        ) : Container(),
                        SizedBox(width: 4),
                        InkWell(
                          onTap : (){
                            controller.setCategoria(controller.categorias[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 4.0,bottom: 4),
                            // decoration: BoxDecoration(
                            //     color:_controller.categorias[index] == _controller.categoriaSelected
                            //         ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                            //   // border: Border(right: BorderSide(color: Colors.grey,width: 1))
                            // ),
                            child: Text("${controller.categorias[index].nome}",
                                style:  TextStyle(
                                    fontWeight: controller.categorias[index] == controller.categoriaSelected
                                        ? FontWeight.w700
                                        : null,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer
                                )
                            ),
                          ),
                        ),
                        SizedBox(width: 4,)
                      ],
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listProdutos() {
    return Expanded(
        child: Observer(
          builder: (context) {
            return ListView.builder(
              itemCount: controller.produtosFiltered.length,
              itemBuilder: (context, index) {
                return CardProduto(
                    controller.produtosFiltered[index],
                  icone: const Icon(Icons.add,color: Colors.green,),
                  functionIcone: (){
                    controller.alterProdutos(controller.produtosFiltered[index],context);
                  },
                );
              },
            );
          }
        )
    );
  }
 Widget _headerDivMain(){
    return CustomTitle(
        title: "Balcão",
        widget:Row(
          children: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -12, end: -8),
              showBadge: true,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              badgeContent: Text(
                controller.vendasComanda.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: OutlinedButton(
                  onPressed: () {
                    DialogComanda().show(context, controller);
                  },
                  child: Text("Comanda",
                      style: TextStyle(color: Colors.yellow.shade700)
                  )
              ),
            ),
            SizedBox(width: 8,),
            OutlinedButton(
                onPressed: (){
                  DialogCaixa().showCaixa(
                    context: context,
                    controller: controller,
                  );
                },
                child: Text(controller.currentCaixa?.ativo == true ? "Aberto" : "Fechado",
                  style:TextStyle(color:controller.currentCaixa?.ativo == true
                      ? Colors.green : Colors.red) ,
                )
            ),
          ],
        )
    );
 }

  Widget _divMain(){
    return Expanded(
      child: Column(
        children: [
          _headerDivMain(),
          SizedBox(height: 4,),
          Expanded(
            child: Column(
              children: [
                _headerTable(),
                Expanded(child: _bodyMain()),
                _footerMain()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyMain(){
    return ListView.builder(
      itemCount: controller.itensSelected.length ,
      itemBuilder: (context, index) {
        return ContainerItem(
            item: controller.itensSelected[index],
            index: index,
            onTap: (){
              controller.setItem(controller.itensSelected[index]);
              DialogItemVenda().show(
                  controller.itensSelected[index],
                  context,
                  controller.tecProduto,
                  controller.tecQuantidade,
                  controller.tecPrecoUnitario,
                  controller.tecPreco,
                      (){
                    controller.onChangeQtd(controller.itensSelected[index]);
                  },
                      (){
                    controller.saveItem(controller.itensSelected[index]);
                  });
            },
            fRem: (){
              controller.alterProdutos(
                  controller.itensSelected[index].produto!,
                  context,
                  operation: 'D'
              );
            },
            fAdd: (){
              controller.alterProdutos(controller.itensSelected[index].produto!,context);
            }
        );
      },
    );
  }

  Widget _footerMain(){
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.shade300)
          )
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
                children: [
                  Text(UtilBrasilFields.obterReal(controller.valorTotal),
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ],
              )
          ),
          controller.vendaSelected != null ? FilledButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: (){
                controller.setVenda(null);
              },
              child: const Text("Cancelar")
          ) : Container(),
          SizedBox(width: 8,),
          FilledButton(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: (){
                DialogEndVenda().endPedido(context, controller);
              },
              child: const Text("Pagamento")
          ),
        ],
      ),
    );
  }

  _headerTable(){
    return Container(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color.fromRGBO(44, 41, 51, 1.0)
            : Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Text("Produto",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
            ),
          ),
          Expanded(
            flex: 5,
            child: Text("Quantidade",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
            ),
          ),
          Expanded(
            flex: 10,
            child: Text("Observação",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              // alignment: Alignment.center,
                child: Text("Total",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                )
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
                child: Text("Ações",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                )
            ),
          ),
        ],
      ),
    );
  }

  _layoutMobile(){
    return Observer(
      builder: (context) {
        return Column(
          children: [
            _headerDivMain(),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: controller.produtosFiltered.length,
                itemBuilder: (context, index) {
                  return CardProduto(
                    controller.produtosFiltered[index],
                    widget: Row(
                      children: [
                        controller.getQtdProduto(controller.produtosFiltered[index]) > 0
                            ? Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      controller.alterProdutos(
                                          controller.produtosFiltered[index],
                                          context,
                                          operation: 'D'
                                      );
                                    },
                                    icon: Icon(Icons.remove,color: Colors.green,)
                                ),
                                Text("${controller.getQtdProduto(controller.produtosFiltered[index])}"),
                              ],
                            ) : Container(),
                        IconButton(
                            onPressed: () {
                              controller.alterProdutos(controller.produtosFiltered[index],context);
                            },
                            icon: Icon(Icons.add,color: Colors.green,)
                        ),
                      ],
                    ),
                    // icone: const Icon(Icons.add,color: Colors.green,),
                    // functionIcone: (){
                    //   _controller.alterProdutos(_controller.produtosFiltered[index],context);
                    // },
                  );},
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Itens: "),
                        Text("${controller.itensSelected.length}",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Valor Total: "),
                        Text("${UtilBrasilFields.obterReal(controller.valorTotal)}",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green)
                        )
                      ],
                    ),
                    controller.vendaSelected != null ? TextButton(
                        onPressed: (){
                          controller.setVenda(null);
                        },
                        child: const Text("Cancelar",style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                        ))
                    ) : Container(),
                    TextButton(
                        onPressed: (){
                          DialogEndVenda().endPedido(context, controller);
                        },
                        child: const Text("Pagamento",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold
                          )
                        )
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
