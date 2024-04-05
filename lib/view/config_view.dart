import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_usuario.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/config_controller.dart';
import 'package:evoz_web/events/dialog_usuario.dart';

class ConfigView extends StatelessWidget {
  final _controller = ConfigController();
  ConfigView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
          onPressed: (){
            DialogUsuario().show(context, _controller);
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          CustomTitle(title: "Configurações"),
          Divider(),
          Expanded(
            child: FutureBuilder(
              future: _controller.getUsuarios(),
              builder: (context, snapshot) {
                return !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                  builder: (context) {
                    return ListView.builder(
                      itemCount: _controller.usuarios.length,
                      itemBuilder: (context, index) {
                        return CardUsuario(_controller.usuarios[index], _controller);
                      },);
                  }
                );
              },),
          )
        ],
      ),
    );
  }
}
