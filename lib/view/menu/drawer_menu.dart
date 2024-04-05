import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/controller/menu_controller.dart';

class DrawerMenu extends StatelessWidget {
  final TMenuController controller;
  DrawerMenu({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Observer(
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _listTile("Balcão", 0, Icon(Icons.computer_outlined), context: context),
                    _listTile("Caixa", 1, Icon(Icons.currency_exchange), context: context),
                    _listTile("Clientes", 2, Icon(Icons.person_2_outlined), context: context),
                    _listTile("Configuração", 3, Icon(Icons.settings_outlined), context: context),
                    _listTile("Dashboard", 4, Icon(Icons.bar_chart_outlined), context: context),
                    _listTile("Estoque", 5, Icon(Icons.sync_alt_outlined), context: context),
                    Global().empresa?.utilizaIfood == true
                        ? _listTile("Ifood", 6, Icon(Icons.storefront_outlined), context: context)
                        : Container(),
                    _listTile("Loja Online", 7, Icon(Icons.table_restaurant_outlined), context: context),
                    _listTile("Mesas", 8, Icon(Icons.table_restaurant_outlined), context: context),
                    // _listTile("Pagamento", 7, Icon(Icons.credit_card)),
                    _listTile("Produtos", 10, Icon(Icons.shopping_bag_outlined), context: context),
                    _listTile("Vendas", 11, Icon(Icons.attach_money_outlined), context: context),

                  ],
                ),
                _listTile("Sair", -1, Icon(Icons.logout_outlined),context: context)
              ],
            ),
          );
        }
      )
    );
  }
  _listTile(String text, int index, Icon icon, {BuildContext? context}){
    return Container(
      decoration: BoxDecoration(
          color: controller.pageIndex == index ? Theme.of(context!).colorScheme.inversePrimary: Colors.transparent,
          borderRadius: BorderRadius.circular(100)
      ),
      child: ListTile(
        leading: icon,
        title: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        onTap: (){
          if(index == - 1){
            Navigator.pop(context!);
            Navigator.pop(context);
          } else
            controller.setPage(index);
        },
      ),
    );
  }
}
