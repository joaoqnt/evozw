import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Estoque.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class EstoqueRepository extends GenericRepository{

  Future<List<Estoque>> getEstoque(String dataInicial, String dataFinal) async{
    List<Estoque> estoques = [];
    try{
      Response response = await apiEvoz("estoques?dataInicio=$dataInicial&dataFim=$dataFinal");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Estoque estoque = Estoque.fromJson(element);
          estoques.add(estoque);
        });
      }
    }catch(e){

    }
    return estoques;
  }

  Future insertEstoque (Estoque estoque) async{
    String estoqueEncoded = jsonEncode(estoque.toJson());
    try{
      Response response = await apiEvoz("insert/estoque",post: true,data: estoqueEncoded);
    } catch(e){
      print("erro ao inserir estoque $e");
    }
  }
}