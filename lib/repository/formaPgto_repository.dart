import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class FormaPgtoRepository extends GenericRepository{
  Future<List<FormaPagamento>> getFormas() async{
    List<FormaPagamento> formas = [];
    Response response = await apiEvoz("formas");
    var results = response.data;
    results.forEach((element){
      FormaPagamento forma = FormaPagamento.fromJson(element);
      formas.add(forma);
    });
    return formas;
  }

  Future<List<FormaPagamento>> getFormasByAtivo(bool ativo) async{
    List<FormaPagamento> formas = [];
    Response response = await apiEvoz("formas/ativo=${ativo == true ? 'S' : 'N'}");
    var results = response.data;
    results.forEach((element){
      FormaPagamento forma = FormaPagamento.fromJson(element);
      formas.add(forma);
    });
    return formas;
  }

  Future insertForma(FormaPagamento formaPagamento) async{
    String produtoEncoded = jsonEncode(formaPagamento.toJson());
    try{
      Response response = await apiEvoz("insert/forma",post: true,data: produtoEncoded);
    } catch(e){

    }
  }
}