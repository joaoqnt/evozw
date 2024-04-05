import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Marca.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class MarcaRepository extends GenericRepository{
  Future<List<Marca>> getMarcas() async{
    List<Marca> marcas = [];
    try{
      Response response = await apiEvoz("marca");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Marca marca = Marca.fromJson(element);
          marcas.add(marca);
        });
      }
    }catch(e){

    }
    return marcas;
  }

  Future insertMarca (Marca marca) async{
    String marcaEncoded = jsonEncode(marca.toJson());
    try{
      Response response = await apiEvoz("insert/marca",post: true,data: marcaEncoded);
    } catch(e){

    }
  }

  Future updateMarca (Marca marca) async{
    String marcaEncoded = jsonEncode(marca.toJson());
    try{
      Response response = await apiEvoz("update/marca",post: true,data: marcaEncoded);
    } catch(e){

    }
  }

  Future deleteMarca (Marca marca) async{
    String marcaEncoded = jsonEncode(marca.toJson());
    try{
      Response response = await apiEvoz("delete/marca",post: true,data: marcaEncoded);
    } catch(e){

    }
  }
}