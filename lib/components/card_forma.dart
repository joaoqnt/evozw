import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/balcao_controller.dart';
import 'package:evoz_web/controller/pagamento_controller.dart';
import 'package:evoz_web/events/dialog_forma.dart';
import 'package:evoz_web/model/FormaPagamento.dart';

class CardForma extends StatelessWidget {
  final PagamentoController controller;
  final FormaPagamento pagamento;

  CardForma(this.pagamento, this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          DialogForma().show(context, controller,forma: pagamento);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Observer(
              builder: (context) {
                return Row(
                  children: [
                    Expanded(
                        child: Text("${pagamento.descricao}",style: TextStyle(fontWeight: FontWeight.w500),)
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever_outlined,color: Colors.red,))
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}