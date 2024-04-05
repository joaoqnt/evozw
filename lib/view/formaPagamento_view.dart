import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/card_forma.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/pagamento_controller.dart';
import 'package:evoz_web/events/dialog_forma.dart';

class FormaPagamentoView extends StatelessWidget {
  FormaPagamentoView({Key? key}) : super(key: key);
  final controller = PagamentoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: FloatingActionButton(
              onPressed: (){
                DialogForma().show(context, controller);
              },
              child: Icon(Icons.add)
          )
      ),
      body: Column(
        children: [
          CustomTitle(
              title: "Formas de Pagamento",
              widget: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer
                ),
                padding: EdgeInsets.all(8),
                child: Text("1"),
              )
          ),
          Divider(),
          FutureBuilder(
            future: controller.getFormas(),
            builder: (context, snapshot) {
              return Observer(
                builder: (context) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: controller.formas.length,
                          itemBuilder: (context, index) {
                            return CardForma(controller.formas[index], controller);
                          }
                      )
                  );
                }
              );
          })
        ],
      ),
    );
  }
}
