import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class DashboardRepository extends GenericRepository{

  Future<List<Map<String,dynamic>>> getDiasVenda(String dataInicial, String dataFinal) async{
    List<Map<String,dynamic>> list = [];
    Response response = await apiEvoz("diaVenda?dtIni=$dataInicial&dtEnd=$dataFinal");
    var element = response.data;
    element.forEach((elemento){
      list.add(elemento);
    });
    return list;
  }

  Future<List<Map<String,dynamic>>> getProdutosVenda(String dataInicial, String dataFinal) async{
    List<Map<String,dynamic>> list = [];
    Response response = await apiEvoz("produtoVenda?dtIni=$dataInicial&dtEnd=$dataFinal");
    var element = response.data;
    element.forEach((elemento){
      list.add(elemento);
    });
    return list;
  }

  Future<List<Map<String,dynamic>>> getHorariosVenda(String dataInicial, String dataFinal) async{
    List<Map<String,dynamic>> list = [];
    Response response = await apiEvoz("horaVenda?dtIni=$dataInicial&dtEnd=$dataFinal");
    var element = response.data;
    element.forEach((elemento){
      list.add(elemento);
    });
    return list;
  }

  Future<double> getTicketMedio(String dataInicial, String dataFinal) async{
    Response response = await apiEvoz("ticketMedio?dtIni=$dataInicial&dtEnd=$dataFinal");
    double valor = 0;
    var element = response.data;
    element.forEach((element){
      Map<String, dynamic> map = element;
      valor = double.parse(map["ticket_medio"].toString());
    });
    return valor;
  }

  Future<String> getCategoriaVenda(String dataInicial, String dataFinal) async{
    Response response = await apiEvoz("categoriaVenda?dtIni=$dataInicial&dtEnd=$dataFinal");
    String valor = '';
    var element = response.data;
    element.forEach((element){
      Map<String, dynamic> map = element;
      valor = map["nome"];
    });
    return valor;
  }

  Future<String> getUsuarioVenda(String dataInicial, String dataFinal) async{
    Response response = await apiEvoz("vendedorVenda?dtIni=$dataInicial&dtEnd=$dataFinal");
    String valor = '';
    var element = response.data;
    element.forEach((element){
      Map<String, dynamic> map = element;
      valor = map["nome"];
    });
    return valor;
  }
}