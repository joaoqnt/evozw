import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/repository/generic_repository.dart';

import '../model/Venda.dart';

class VendaRepository extends GenericRepository{
  Future<int> insertVenda(Venda venda) async{
    int id = 0;
    String vendaEncoded = jsonEncode(venda.toJson());
    try{
      Response response = await apiEvoz("insert/venda",post: true,data: vendaEncoded);
      id = response.data;
    } catch(e){
      print("erro ao inserir venda $e");
    }
    return id;
  }

  Future updateVenda(Venda venda) async{
    String vendaEncoded = jsonEncode(venda.toJson());
    try{
       await apiEvoz("update/venda",post: true,data: vendaEncoded);
    } catch(e){
      print("erro ao atualizar venda $e");
    }
  }

  Future<List<Venda>> getVendas(String dataInicial, String dataFinal) async{
    List<Venda> vendas = [];
    Response response = await apiEvoz("vendas?dataInicio=$dataInicial&dataFim=$dataFinal");
    var element = response.data;
    element.forEach((element){
      Venda venda = Venda.fromJson(element);
      vendas.add(venda);
    });
    return vendas;
  }

  Future<List<Venda>> getVendasPendentes() async{
    List<Venda> vendas = [];
    Response response = await apiEvoz("comandas?comanda=S");
    var element = response.data;
    element.forEach((element){
      Venda venda = Venda.fromJson(element);
      vendas.add(venda);
    });
    return vendas;
  }
}