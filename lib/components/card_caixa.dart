import 'package:evoz_web/model/CaixaLog.dart';
import 'package:flutter/material.dart';

import '../util/FormatDate.dart';

class CardCaixa extends StatelessWidget{
  CaixaLog caixa;

  CardCaixa(this.caixa);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(child: Icon(Icons.currency_exchange)),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("${caixa.descricao}")),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Data: ",style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${FormatingDate.getDate(
                          caixa.dataRegistro,
                          FormatingDate.formatDDMMYYYYHHMM)}"
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}