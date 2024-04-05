import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Empresa.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class EmpresaRepository extends GenericRepository{
  Future<Empresa?> getEmpresa() async{
    Empresa? empresa;
    try{
      Response response = await apiEvoz("empresa");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          empresa = Empresa.fromJson(element);
        });
      }
    }catch(e){

    }
    return empresa;
  }

  Future updateEmpresa (Empresa empresa) async{
    String empresaEncoded = jsonEncode(empresa.toJson());
    try{
      Response response = await apiEvoz("update/empresa",post: true,data: empresaEncoded);
    } catch(e){

    }
  }
}