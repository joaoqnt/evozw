import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Mesa.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class MesaRepository extends GenericRepository{
  Future<List<Mesa>> getMesas() async{
    List<Mesa> mesas = [];
    Response response = await apiEvoz("mesas");
    var element = response.data;
    element.forEach((element){
      Mesa mesa = Mesa.fromJson(element);
      mesas.add(mesa);
    });
    return mesas;
  }

  Future insertMesa(Mesa mesa) async{
    String mesaEncoded = jsonEncode(mesa.toJson());
    try{
      Response response = await apiEvoz("insert/mesa",post: true,data: mesaEncoded);
    } catch(e){
      print(e);
    }
  }

  Future updateMesa(Mesa mesa) async{
    String mesaEncoded = jsonEncode(mesa.toJson());
    try{
      Response response = await apiEvoz("update/mesa",post: true,data: mesaEncoded);
    } catch(e){
      print(e);
    }
  }

  Future deleteMesa(Mesa mesa) async{
    String mesaEncoded = jsonEncode(mesa.toJson());
    try{
      Response response = await apiEvoz("delete/mesa",post: true,data: mesaEncoded);
    } catch(e){
      print(e);
    }
  }
}