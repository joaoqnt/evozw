import 'dart:convert';

import 'package:dio/dio.dart';

import '../model/ItemVenda.dart';
import 'generic_repository.dart';

class ItemVendaRepository extends GenericRepository{
  Future insertItens(ItemVenda item) async{
    String vendaEncoded = jsonEncode(item.toJson());
    try{
      Response response = await apiEvoz("insert/item",post: true,data: vendaEncoded);
    } catch(e){
      print("erro ao inserir item $e");
    }
  }

  Future deleteItens(int venda) async{
    try{
      Response response = await apiEvoz("delete/item?venda=$venda",post: true);
    } catch(e){
      print("erro ao deletar item $e");
    }
  }

  Future<List<ItemVenda>> getItens(List<int> vendas) async{
    List<ItemVenda> itens = [];
    Response response = await apiEvoz("itens?vendas=${vendas.join(',')}");
    var element = response.data;
    element.forEach((element){
      ItemVenda item = ItemVenda.fromJson(element);
      itens.add(item);
    });
    return itens;
  }
}