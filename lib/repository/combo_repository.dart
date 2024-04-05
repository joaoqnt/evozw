import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/CabCombo.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class ComboRepository extends GenericRepository{

  Future <List<CabCombo>> getCombos() async{
    List<CabCombo> combos = [];
    try{
      Response response = await apiEvoz("combos");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          CabCombo cabCombo = CabCombo.fromJson(element);
          combos.add(cabCombo);
        });
      }
    }catch(e){

    }
    return combos;
  }

  Future<int> insertCombo (CabCombo cabCombo) async{
    String cabComboEncoded = jsonEncode(cabCombo.toJson());
    int id = 0;
    try{
      Response response = await apiEvoz("insert/combo",post: true,data: cabComboEncoded);
      id = response.data;
    } catch(e){

    }
    return id;
  }

  Future updateCombo (CabCombo cabCombo) async{
    String cabComboEncoded = jsonEncode(cabCombo.toJson());
    try{
      Response response = await apiEvoz("update/combo",post: true,data: cabComboEncoded);
    } catch(e){

    }
  }

  Future deleteCombo (CabCombo cabCombo) async{
    String cabComboEncoded = jsonEncode(cabCombo.toJson());
    try{
      Response response = await apiEvoz("delete/combo",post: true,data: cabComboEncoded);
    } catch(e){

    }
  }
}