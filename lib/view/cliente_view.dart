import 'package:evoz_web/components/circle_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_cliente.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/cliente_controller.dart';
import 'package:evoz_web/events/dialog_cliente.dart';

class ClienteView extends StatelessWidget {
  ClienteView({Key? key}) : super(key: key);
  final _controller = ClienteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
          onPressed: (){
            DialogCliente().show(context, _controller);
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
                      title: "Clientes",
                      widget: CircleNumber(_controller.clientes.length)
                  ),
                  Divider(),
                  CustomTextField(
                      tec: _controller.tecBusca,
                      label: "Pesquisar",
                      suffixIcon: Icon(Icons.search)
                  ),
                  SizedBox(height: 8)
                ],
              );
            }
          ),
          FutureBuilder(
            future: _controller.getClientes(),
            builder: (context, snapshot) {
              return Expanded(
                  child: !snapshot.hasData ? Center(child: CircularProgressIndicator()): Observer(
                    builder: (context) {
                      return ListView.builder(
                          itemCount: _controller.clientes.length,
                          itemBuilder: (context, index) {
                            return CardCliente(cliente: _controller.clientes[index],controller: _controller);
                          },
                      );
                    }
                  )
              );
            },)
        ],
      ),
    );
  }
}
