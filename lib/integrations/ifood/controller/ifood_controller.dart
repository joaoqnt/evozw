import 'dart:async';
import 'dart:convert';

import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/integrations/ifood/repository/merchant/merchants_repository.dart';
import 'package:evoz_web/util/global.dart';
import 'package:mobx/mobx.dart';

part 'ifood_controller.g.dart';

class IfoodController = _IfoodController with _$IfoodController;

abstract class _IfoodController with Store{
  final _mRepository = MerchantRepository();
  @observable
  Ifood? ifood;
  String html = '''
    <head>
        <!-- Start of iFood Widget script-->
        <!--script async src="https://widgets.ifood.com.br/widget.js"></script>
        <script>
        window.addEventListener('load', () => {
            iFoodWidget.init({
            widgetId: '12ac48cc-2a2f-4346-a6f1-a3b6af344939',
            merchantIds: [
                
            ],
            });
        });
        </script-->
        <body>
          <p>Teste</p>
        </body>
    <!-- End of iFood Widget script -->
    </head>
  ''';

  @action
  Future<Ifood> loadAll() async{
    // ifood = Global().iFood;
    Global().iFood!.merchantStatus = await _mRepository.statusMerchant(ifood!.merchantId!);
    ifood = Global().iFood;
    return ifood!;
  }
}