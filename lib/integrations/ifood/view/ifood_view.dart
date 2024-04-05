import 'dart:html';

import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/balcao_controller.dart';
import 'package:evoz_web/integrations/ifood/controller/ifood_controller.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class IfoodPageView extends StatelessWidget {
  BalcaoController bController = BalcaoController();
  IfoodPageView({Key? key, required this.bController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.end,
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               SizedBox(
                   width: MediaQuery.of(context).size.width * 0.85,
                   height: MediaQuery.of(context).size.height * 0.75,
                   child: HtmlElementView(viewType: 'ifood-html-view')
               ),
              ],
            )
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     SizedBox(
          //         width: MediaQuery.of(context).size.width <= 650
          //             ?  MediaQuery.of(context).size.width - 100
          //             : MediaQuery.of(context).size.width - 400,
          //         height: MediaQuery.of(context).size.height - 150,
          //         child: HtmlElementView(viewType: 'ifood-html-view')
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
