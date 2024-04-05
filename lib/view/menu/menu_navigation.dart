import 'dart:html';

import 'package:evoz_web/integrations/ifood/view/ifood_view.dart';
import 'package:evoz_web/util/global.dart';
import 'package:evoz_web/view/balcao/balcao_view.dart';
import 'package:evoz_web/view/caixa_view.dart';
import 'package:evoz_web/view/loja_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/controller/menu_controller.dart';
import 'package:evoz_web/view/balcao/page/balcao_page_view.dart';
import 'package:evoz_web/view/cliente_view.dart';
import 'package:evoz_web/view/config_view.dart';
import 'package:evoz_web/view/dashboard_view.dart';
import 'package:evoz_web/view/estoque_view.dart';
import 'package:evoz_web/view/formaPagamento_view.dart';
import 'package:evoz_web/view/menu/drawer_menu.dart';
import 'package:evoz_web/view/mesa_view.dart';
import 'package:evoz_web/view/produtos/produto_view.dart';
import 'package:evoz_web/view/vendas_view.dart';
import 'dart:html' as html;

class MenuNavigation extends StatelessWidget {
  MenuNavigation({Key? key}) : super(key: key);

  final _controller = TMenuController();

  final List<Widget> _pages = [
    BalcaoView(),
    // BalcaoPageView(),
    CaixaView(),
    ClienteView(),
    ConfigView(),
    DashboardView(),
    EstoqueView(),
    Global().empresa?.utilizaIfood == true ? FormaPagamentoView() : Container(),
    LojaView(),
    MesaView(),
    FormaPagamentoView(),
    ProdutoView(),
    VendaView(),
  ];

  // @override
  // initState() {
  //   getEmpresa();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Container(
            height: 50,
            child: InkWell(
              onTap: () {
                _controller.setPage(0);
              },
              child: Image(
                  // image: AssetImage('assets/LOGO.png')
                  image: AssetImage('assets/evoz-logo.png')
              ),
            )
          )
      ),
      drawer: DrawerMenu(controller: _controller),
      body: FutureBuilder(
        future: _controller.getEmpresa(),
        builder: (context,snapshot) {
          return Observer(
            builder: (context) {
              return !snapshot.hasData ? Center(child: CircularProgressIndicator()) :  Column(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: _pages[_controller.pageIndex]
                      )
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }

  Future getEmpresa() async{
    await _controller.getEmpresa();
  }
}
