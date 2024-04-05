import 'package:flutter/material.dart';

class Mesa {
  int? id;
  String? descricao;
  int? cliente;
  String? nomeCliente;
  String? statusOcupacao;
  DateTime? dataAbertura;
  DateTime? dataCriacao;
  DateTime? ultimaVenda;
  double? valorTotal;
  String? statusPagamento;
  Color? colors;
  Color? borderColors;

  Mesa(
      {this.id,
        this.descricao,
        this.cliente,
        this.nomeCliente,
        this.statusOcupacao,
        this.dataAbertura,
        this.dataCriacao,
        this.ultimaVenda,
        this.valorTotal,
        this.statusPagamento});

  Mesa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    cliente = json['cliente'];
    nomeCliente = json['nomeCliente'];
    statusOcupacao = json['statusOcupacao'];
    try{
      dataAbertura = DateTime.parse(json['dataAbertura']);
    }catch(e){

    }
    try{
      dataCriacao = DateTime.parse(json['dataCriacao']);
    }catch(e){

    }
    try{
      ultimaVenda = DateTime.parse(json['ultimoPedido']);
    }catch(e){

    }
    valorTotal = json['valorTotal'];
    statusPagamento = json['statusPagamento'];
    colors = getColors(json['statusOcupacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['cliente'] = this.cliente;
    data['nomeCliente'] = this.nomeCliente;
    data['statusOcupacao'] = this.statusOcupacao;
    data['dataAbertura'] = this.dataAbertura.toString();
    data['dataCriacao'] = this.dataCriacao.toString();
    data['ultimoPedido'] = this.ultimaVenda.toString();
    data['valorTotal'] = this.valorTotal;
    data['statusPagamento'] = this.statusPagamento;
    return data;
  }

  Color getColors(String situacao){
    switch(situacao){
      case "Disponível":{
        borderColors = Colors.green;
        return Colors.greenAccent.shade700;
      }
      case "Em Uso":{
        borderColors = Colors.yellow.shade900;
        return Colors.yellow.shade700;
      }
      default:{
        borderColors = Colors.yellow;
        return Colors.yellowAccent;
      }
    }
  }
}
