import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/PagamentoVenda.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class PagamentoVendaRepository extends GenericRepository{
  Future insertPagamentos(PagamentoVenda pagamentos) async{
    String vendaEncoded = jsonEncode(pagamentos.toJson());
    try{
      Response response = await apiEvoz("insert/pagamentoVenda",post: true,data: vendaEncoded);
    } catch(e){
      print("erro ao inserir pagamentoVenda $e");
    }
  }
  
  Future<List<PagamentoVenda>> getPagamentoVendas(List<int> vendas) async{
    List<PagamentoVenda> pagamentos = [];
    Response response = await apiEvoz("pagamentoVendas?vendas=${vendas.join(',')}");
    var element = response.data;
    element.forEach((element){
      PagamentoVenda pagamentoVenda = PagamentoVenda.fromJson(element);
      pagamentos.add(pagamentoVenda);
    });
    return pagamentos;
  }
}