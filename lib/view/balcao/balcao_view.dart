import 'package:evoz_web/controller/balcao_controller.dart';
import 'package:evoz_web/integrations/ifood/view/ifood_view.dart';
import 'package:evoz_web/util/global.dart';
import 'package:evoz_web/view/balcao/page/balcao_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BalcaoView extends StatelessWidget {
  BalcaoView({Key? key}) : super(key: key);
  final _controller = BalcaoController();

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [BalcaoPageView(),IfoodPageView(bController: _controller)];
    return Scaffold(
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return Global().empresa?.utilizaIfood == true ? DefaultTabController(
                length: 2,
                initialIndex: _controller.pageSelected,
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: Theme.of(context).colorScheme.primary),
                  ),

                  onTap: (value) {
                    _controller.setPage(value);
                  },
                  tabs: [
                    Tab(child: Text('Balcão')),
                    Tab(child: Text('Ifood')),
                  ],
                ),
              ) : Container();
            }
          ),
          FutureBuilder(
            future: _controller.createLayoutIfood(),
            builder: (context, snapshot) {
              return Observer(
                builder: (context) {
                  return Expanded(child: _pages[_controller.pageSelected]);
                }
              );
            })
        ],
      ),
    );
  }
}
