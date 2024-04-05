import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Marca.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/repository/categoria_repository.dart';
import 'package:evoz_web/repository/generic_repository.dart';
import 'package:evoz_web/repository/marca_repository.dart';
import 'package:evoz_web/repository/produtoTamanho_repository.dart';

import '../model/ProdutoTamanho.dart';

class ProdutoRepository extends GenericRepository{

  final _cRepository = CategoriaRepository();
  final _mRepository = MarcaRepository();
  final _tRepository = ProdutoTamanhoRepository();
  List<Categoria> categorias = [];
  List<Marca> marcas = [];
  List<ProdutoTamanho> tamanhos = [];

  Future<List<Produto>> getProdutos() async{
    List<Produto> produtos = [];
    categorias = await _cRepository.getCategorias();
    marcas = await _mRepository.getMarcas();
    tamanhos = await _tRepository.getProdutoTamanho();
    try{
      // produtos.forEach((produto) {
      //   tamanhos.where((element) => element.produto == produto.id).forEach((element) {
      //     produto.tamanhos.add(element);
      //   });
      // });
      Response response = await apiEvoz("produto");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Produto produto = Produto.fromJson(element);
          categorias.where((cat) => cat.id == element['categoria']).forEach((element) {
            produto.categoria = element;
          });
          marcas.where((mar) => mar.id == element['marca']).forEach((marca) {
            produto.marca = marca;
          });
          tamanhos.where((element) => element.produto == produto.id).forEach((element) {
            produto.tamanhos.add(element);
          });
          produtos.add(produto);
        });
      }
    }catch(e){

    }
    return produtos;
  }

  Future<List<Produto>> getProdutosAtivos(bool ativo) async{
    List<Produto> produtos = [];
    categorias = await _cRepository.getCategorias();
    try{
      Response response = await apiEvoz("produto/?ativo=${ativo ? 'S' : 'N'}");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Produto produto = Produto.fromJson(element);
          categorias.where((cat) => cat.id == element['categoria']).forEach((element) {
            produto.categoria = element;
          });
          produtos.add(produto);
        });
      }
    }catch(e){

    }
    return produtos;
  }

  Future<int> insertProduto(Produto produto) async{
    String produtoEncoded = jsonEncode(produto.toJson());
    int id = 0;
    try{
      Response response = await apiEvoz("insert/produto",post: true,data: produtoEncoded);
      id = response.data;
    } catch(e){

    }
    return id;
  }

  Future deleteProduto(Produto produto) async{
    String produtoEncoded = jsonEncode(produto.toJson());
    try{
      Response response = await apiEvoz("delete/produto",post: true,data: produtoEncoded);
    } catch(e){

    }
  }

  Future updateProduto(Produto produto) async{
    String produtoEncoded = jsonEncode(produto.toJson());
    try{
      Response response = await apiEvoz("update/produto",post: true,data: produtoEncoded);
    } catch(e){

    }
  }

  // Future loadImage(Produto produto, Uint8List bytes) async{
  //   await uploadImage(produto.nome!, bytes);
  // }
}