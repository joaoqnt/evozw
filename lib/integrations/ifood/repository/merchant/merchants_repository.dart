import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/integrations/ifood/repository/ifood_repository.dart';
import 'package:evoz_web/util/global.dart';

class MerchantRepository extends IfoodRepository{
  Future getMerchants() async{
    Response response = await apiIfood("merchants", Global().iFood!,);
    if(response.statusCode == 200){
      var results = jsonDecode(response.data);
      results.forEach((element){
        Ifood iFood = Ifood.fromJson(element);
        Global().iFood?.merchantName = iFood.merchantName;
        Global().iFood?.merchantId = iFood.merchantId;
        Global().iFood?.merchantCorporateName = iFood.merchantCorporateName;
      });
    }
  }

  Future statusMerchant(String merchantId) async{
    Response response = await apiIfood("merchant/status?merchantId=$merchantId", Global().iFood!);
    var results = response.data;
    results.forEach((element){
      print(element["state"]);
    });
  }
}