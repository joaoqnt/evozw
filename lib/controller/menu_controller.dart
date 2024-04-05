import 'dart:async';

import 'package:evoz_web/integrations/ifood/repository/authentication/authentication_repository.dart';
import 'package:evoz_web/integrations/ifood/repository/merchant/merchants_repository.dart';
import 'package:evoz_web/integrations/ifood/repository/order/events/events_pool_repository.dart';
import 'package:evoz_web/model/Empresa.dart';
import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/repository/empresa_repository.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'menu_controller.g.dart';

class TMenuController = _TMenuController with _$TMenuController;

abstract class _TMenuController with Store{
  List<Widget> pages = [];
  final _empRepository = EmpresaRepository();
  final _eRepository = EventsPoolRepository();
  final _aRepository = AuthenticationRepository();
  final _mRepository = MerchantRepository();
  @observable
  int pageIndex = 0;
  @observable
  Map<int,bool> mapExpanded = ObservableMap.of({});
  SharedPreferences? sp;

  @action
  setPage(int index){
    pageIndex = index;
  }

  @action
  setExpanded(int index){
    mapExpanded[index] = (mapExpanded[index]??false) == true ? false : true;
  }

  Future<Empresa> getEmpresa() async{
    sp = await SharedPreferences.getInstance();
    Global().idEmpresa = sp!.getString("id")??'';
    Empresa? empresa = await _empRepository.getEmpresa();
    Global().empresa = empresa!;
    if(empresa.iClientId != null && empresa.utilizaIfood == true){
      Global().iFood = Ifood(
          iClientId: empresa.iClientId,
          iClientSecret: empresa.iClientSecret,
          iCredentials: empresa.iCredentials,
          iLojaId: empresa.iLojaId
      );
      await _aRepository.getAcessToken();
      await _loadMerchant();
    }
    if(Global().iFood?.iClientId != null){
      await _eventPooling();
    }
    return Global().empresa!;
  }

  _eventPooling() async{
    Timer.periodic(Duration(seconds: 30), (Timer timer) async{
      await _eRepository.eventsPooling();
    });
  }

  _loadMerchant() async{
    await _mRepository.getMerchants();
  }
}