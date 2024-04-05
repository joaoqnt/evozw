import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class CategoriaRepository extends GenericRepository{

  Future<List<Categoria>> getCategorias() async{
    List<Categoria> categorias = [];
    try{
      Response response = await apiEvoz("categoria");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Categoria categoria = Categoria.fromJson(element);
          categorias.add(categoria);
        });
      }
    }catch(e){

    }
    return categorias;
  }

  Future postCategoria(Categoria categoria) async{
    String categoriaEncoded = jsonEncode(categoria.toJson());
    try{
      Response response = await apiEvoz("insert/categoria",post: true,data: categoriaEncoded);
    } catch(e){

    }
  }

  Future deleteCategoria(Categoria categoria) async{
    String categoriaEncoded = jsonEncode(categoria.toJson());
    try{
      Response response = await apiEvoz("delete/categoria",post: true,data: categoriaEncoded);
    } catch(e){

    }
  }

  Future updateCategoria(Categoria categoria) async{
    String categoriaEncoded = jsonEncode(categoria.toJson());
    try{
      Response response = await apiEvoz("update/categoria",post: true,data: categoriaEncoded);
    } catch(e){

    }
  }

}