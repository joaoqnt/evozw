import 'package:evoz_web/components/card_estoque.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/estoque_controller.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EstoqueView extends StatelessWidget {
  EstoqueView({Key? key}) : super(key: key);
  final _controller = EstoqueController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return CustomTitle(
                  title: "Estoques",
                  widget: Row(
                    children: [
                      IconButton(
                          onPressed: () async{
                            await _controller.setDateIni(context);
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
          Observer(
            builder: (context) {
              return Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                          tec: _controller.tecPesquisa,
                          label: "Pesquisar",
                          hint: "Digite o nome do produto",
                        suffixIcon: Icon(Icons.search),
                        onChanged: (){
                            _controller.filter();
                        },
                      )
                  ),
                ],
              );
            }
          ),
          SizedBox(height: 8,),
          FutureBuilder(
            future: _controller.getEstoques(),
            builder: (context, snapshot) {
              return Expanded(
                child: !snapshot.hasData ? Center(child: CircularProgressIndicator(),) :
                Observer(
                  builder: (context) {
                    return ListView.builder(
                      itemCount: _controller.estoquesFiltered.length,
                      itemBuilder: (context, index) {
                        return CardEstoque(estoque: _controller.estoquesFiltered[index]);
                      }
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
