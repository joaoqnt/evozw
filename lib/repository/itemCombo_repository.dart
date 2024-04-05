import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/CabCombo.dart';
import 'package:evoz_web/model/ItemCombo.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class ItemComboRepository extends GenericRepository{
  Future <List<ItemCombo>> getItensCombos() async{
    List<ItemCombo> combos = [];
    try{
      Response response = await apiEvoz("itensCombo");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          ItemCombo item = ItemCombo.fromJson(element);
          combos.add(item);
        });
      }
    }catch(e){

    }
    return combos;
  }

  Future insertItemCombo (ItemCombo itemCombo) async{
    String itemComboEncoded = jsonEncode(itemCombo.toJson());
    try{
      Response response = await apiEvoz("insert/itemCombo",post: true,data: itemComboEncoded);
    } catch(e){

    }
  }

  Future updateItemCombo (ItemCombo itemCombo) async{
    String itemComboEncoded = jsonEncode(itemCombo.toJson());
    try{
      Response response = await apiEvoz("update/itemCombo",post: true,data: itemComboEncoded);
    } catch(e){

    }
  }

  Future deleteItemCombo (CabCombo combo) async{
    try{
      Response response = await apiEvoz("delete/itemCombo?combo=${combo.id}",post: true,);
    } catch(e){

    }
  }
}