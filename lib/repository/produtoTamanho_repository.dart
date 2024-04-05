import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/model/ProdutoTamanho.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class ProdutoTamanhoRepository extends GenericRepository{

  Future<List<ProdutoTamanho>> getProdutoTamanho() async{
    List<ProdutoTamanho> produtos = [];
    try{
      Response response = await apiEvoz("produtoTamanho");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          ProdutoTamanho produto = ProdutoTamanho.fromJson(element);
          print(element);
          produtos.add(produto);
        });
      }
    }catch(e){

    }
    return produtos;
  }

  Future<int> insertProdutoTamanho(ProdutoTamanho produto) async{
    String produtoEncoded = jsonEncode(produto.toJson());
    print(produtoEncoded);
    int id = 0;
    try{
      Response response = await apiEvoz("insert/produtoTamanho",post: true,data: produtoEncoded);
      id = response.data;
    } catch(e){

    }
    return id;
  }

  Future deleteProdutoTamanho (Produto produto) async{
    try{
      Response response = await apiEvoz("delete/produtoTamanho?produto=${produto.id}",post: true,);
    } catch(e){

    }
  }

  Future updateProdutoTamanho(ProdutoTamanho produto) async{
    String produtoEncoded = jsonEncode(produto.toJson());
    try{
      Response response = await apiEvoz("update/produtoTamanho",post: true,data: produtoEncoded);
    } catch(e){

    }
  }
}