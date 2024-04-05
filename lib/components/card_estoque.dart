import 'package:evoz_web/model/Estoque.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:flutter/material.dart';

class CardEstoque extends StatelessWidget{
  Estoque estoque;
  CardEstoque({Key? key,required this.estoque}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.sync_alt_outlined),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${estoque.operacao}"),
                    Row(
                      children: [
                        Text("Data: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${FormatingDate.getDate(
                            estoque.dataAlteracao!, FormatingDate.formatDDMMYYYYHHMM)}"
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Responsável: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${estoque.usuario}"),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Estoque atual: ",),
                      Text("${estoque.estoqueAtual}",
                        style:  TextStyle(fontSize: 16, color: (estoque.estoqueAtual??0) < 5
                            ? Colors.red
                            : Colors.green)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}