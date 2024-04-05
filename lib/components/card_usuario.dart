import 'package:flutter/material.dart';
import 'package:evoz_web/controller/config_controller.dart';
import 'package:evoz_web/events/dialog_usuario.dart';
import 'package:evoz_web/model/Usuario.dart';

class CardUsuario extends StatelessWidget {
  Usuario usuario;
  ConfigController controller;

  CardUsuario(this.usuario, this.controller);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DialogUsuario().show(context, controller, usuario: usuario);
      },
      child: Card(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(child: Text(usuario.nome!.substring(0,1))),
                SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${usuario.nome}"),
                    Row(
                      children: [
                        Text("Perfil: "),
                        Text("${usuario.perfil}",
                          style: TextStyle(
                            color: usuario.perfil == 'admin'
                                ? Colors.green.shade700
                                : usuario.perfil == 'balconista' ? Colors.cyan : Colors.deepPurple
                          )
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}