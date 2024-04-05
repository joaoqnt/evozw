import 'package:evoz_web/controller/mesa_controller.dart';
import 'package:evoz_web/events/dialog_confirm.dart';
import 'package:evoz_web/events/dialog_mesa.dart';
import 'package:evoz_web/model/Mesa.dart';
import 'package:flutter/material.dart';

class ContainerMesa extends StatelessWidget{
  final Mesa mesa;
  final MesaController controller;

  ContainerMesa({
    required this.mesa,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DialogMesa().show(context, controller,mesa: mesa);
      },
      child: Container(
        decoration: BoxDecoration(
          color: mesa.colors!,
          border: Border.all(color: mesa.borderColors!),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("${mesa.descricao}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${mesa.id}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 30
                      )
                  ),
                ],
              ),
            ),
            mesa.statusOcupacao == "Disponível" ?
            IconButton(onPressed: (){
              DialogConfirm().show(
                  context,
                  "Excluir Mesa",
                  controller.isLoading,
                      () async{
                    await controller.deleteMesa(mesa);
                  }
              );
            }, icon: Icon(Icons.delete_outline)
            ) : Container()
          ],
        ),
      ),
    );
  }
}