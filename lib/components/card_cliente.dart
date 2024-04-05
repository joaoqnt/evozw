import 'package:evoz_web/events/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/controller/cliente_controller.dart';
import 'package:evoz_web/events/dialog_cliente.dart';
import 'package:evoz_web/model/Cliente.dart';

class CardCliente extends StatelessWidget {
  Cliente cliente;
  ClienteController controller;
  CardCliente({Key? key,required this.cliente, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          DialogCliente().show(context, controller,cliente: cliente);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(child: Text(cliente.nome!.substring(0,1))),
                SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cliente.nome!),
                      // SizedBox(height: 8,),
                      Text("${cliente.rua}, ${cliente.numero} - ${cliente.cidade}, ${cliente.uf}")
                    ],
                  ),
                ),
                IconButton(
                    onPressed: (){
                      DialogConfirm().show(
                          context,
                          "Excluir o cliente",
                          controller.isLoading,
                              (){
                            controller.deleteCliente(cliente);
                              }
                      );
                    },
                    icon: Icon(Icons.delete_forever_outlined,color: Colors.red,)
                )
              ],
            ),
          ),
        )
    );
  }
}
