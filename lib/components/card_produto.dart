import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/model/Produto.dart';

class CardProduto extends StatelessWidget {
  final Produto produto;
  final Icon? icone;
  final Function? functionIcone;
  final Function? functionOntap;
  final Widget? widget;

  CardProduto(this.produto, {this.icone, this.functionIcone,this.functionOntap,this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        functionOntap!= null ? functionOntap!() : null;
      },
      child: Card(
            child: Container(
                padding: EdgeInsets.all(8),
                color: produto.ativo! ? Colors.transparent : Colors.red.shade100,
                child: Row(
                  children: [
                    InkWell(
                        child: SizedBox(
                            height: 60,
                            width: 60,
                            child: CachedNetworkImage(
                                imageUrl: produto.urlImage??'',
                              errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.image_not_supported_outlined)),
                            )
                        ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: CachedNetworkImage(
                                    imageUrl: produto.urlImage??'',
                                    errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.image_not_supported_outlined)),
                                  )
                              );
                              // return AlertDialog(
                              //   content: Image.network(produto.urlImage!),
                              // );
                            },
                        );
                      },
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${produto.nome}"),
                          Row(
                            children: [
                              Text("Estoque: "),
                              Text("${produto.utilizaEstoque == true
                                  ? produto.estoque
                                  : "Não utiliza"}",
                                style: TextStyle(color: produto.utilizaEstoque == true && produto.estoque! < 5
                                    ? Colors.red
                                    : null,
                                  fontWeight: produto.utilizaEstoque == true ? FontWeight.bold : null
                                ),
                              )
                            ],
                          ),
                          Text(UtilBrasilFields.obterReal(produto.preco??0),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green
                            ),
                          ),
                          Row(
                            children: [
                              for(int i = 0; i < produto.tamanhos.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                      padding: EdgeInsets.only(top: 2,bottom: 2,right: 6,left: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("${produto.tamanhos[i].tamanho}")
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                    icone != null ?
                    IconButton(
                        onPressed: (){
                          functionIcone != null ? functionIcone!() : null;
                        },
                        icon: icone!
                    ) : Container(),
                    widget != null ? widget! : Container()
                  ],
                )
            )
        ),
    );
  }
}
