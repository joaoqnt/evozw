import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Caixa.dart';
import 'package:evoz_web/repository/generic_repository.dart';
import 'package:evoz_web/repository/usuario_repository.dart';
import 'package:evoz_web/util/global.dart';

class CaixaRepository extends GenericRepository{

  Future<Caixa?> getCaixa() async{
    var http = Dio();
    UsuarioRepository repository = UsuarioRepository();
    Caixa? caixa;
    String ip = "caixa/aberto?usuario=${Global().usuario!.id}";
    Response response = await apiEvoz(ip);
    if(response.statusCode == 200){
      try{
        var results = response.data;
        caixa = Caixa.fromJson(results);
        caixa.usuario = await repository.getById(results['usuario']);
      }catch(e){
        // print(e);
      }
    }
    return caixa;
  }

  Future insertCaixa(Caixa caixa) async{
    String caixaEncoded = jsonEncode(caixa.toJson());
    try{
      Response response = await apiEvoz("insert/caixa",post: true,data: caixaEncoded);
    } catch(e){
      print(e);
    }
  }

  Future updateCaixa(Caixa caixa) async{
    String caixaEncoded = jsonEncode(caixa.toJson());
    try{
      Response response = await apiEvoz("update/caixa",post: true,data: caixaEncoded);
    } catch(e){
      print(e);
    }
  }
}