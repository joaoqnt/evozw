import 'package:evoz_web/view/produtos/page/marca_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/controller/produto_controller.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/view/produtos/page/categoria_page_view.dart';
import 'package:evoz_web/view/produtos/page/combo/combos_list_page_view.dart';
import 'package:evoz_web/view/produtos/page/produto_page_view.dart';

class ProdutoView extends StatelessWidget {
  ProdutoView({Key? key}) : super(key: key);
  final _controller = ProdutoController();
  final _pages = [
    ProdutoPageView(),
    CategoriaPageView(),
    ComboListPageView(),
    MarcaPageView()
  ];

  @override
  Widget build(BuildContext context) {
    _controller.setPage(0);
    return Observer(
      builder: (context) {
        return Scaffold(
          body: Column(
            children: [
              DefaultTabController(
                length: _pages.length,
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: Theme.of(context).colorScheme.primary),
                  ),
                  onTap: (value) {
                    _controller.setPage(value);
                  },
                  tabs: [
                    Tab(child: Text('Produtos')),
                    Tab(child: Text('Categorias')),
                    Tab(child: Text('Combos')),
                    Tab(child: Text('Marcas')),
                  ],
                ),
              ),
              VerticalDivider(),
              Expanded(child: _pages[_controller.page])
            ],
          ),
        );
      }
    );
  }

}
