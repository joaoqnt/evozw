import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/caixa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/card_caixa.dart';

class CaixaView extends StatelessWidget {
  CaixaView({Key? key}) : super(key: key);
  final _controller = CaixaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return CustomTitle(
                  title: "Fluxo de Caixa",
                  widget: Row(
                    children: [
                      IconButton(
                          onPressed: (){
                            _controller.setDateIni(context);
                          },
                          icon: Icon(Icons.calendar_month)
                      ),
                      Text("${_controller.dtInicial} - ${_controller.dtFinal}")
                    ],
                  )
              );
            }
          ),
          Divider(),
          FutureBuilder(
              future: _controller.getCaixas(),
              builder:(context, snapshot) {
                return Expanded(
                    child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                      builder: (context) {
                        return ListView.builder(
                            itemCount: _controller.caixas.length,
                            itemBuilder: (context, index) {
                              return CardCaixa(_controller.caixas[index]);
                            }
                        );
                      }
                    )
                );
              },
          )
        ],
      ),
    );
  }
}
