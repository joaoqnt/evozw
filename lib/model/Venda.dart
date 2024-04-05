import 'package:evoz_web/model/ItemVenda.dart';
import 'package:evoz_web/model/Mesa.dart';
import 'package:evoz_web/model/Usuario.dart';
import 'package:evoz_web/util/global.dart';

import 'PagamentoVenda.dart';

class Venda{
  int? id;
  String? cliente;
  double? valorBruto;
  double? valorLiquido;
  double? valorTroco;
  double? desconto;
  Usuario? usuario;
  int? mesa;
  bool? comanda;
  String? status;
  DateTime? dataPedido;
  DateTime? dataAlteracao;
  List<ItemVenda> itens = [];
  List<PagamentoVenda> pagamentos = [];

  Venda({
    this.id,
    this.cliente,
    this.valorBruto,
    this.valorLiquido,
    this.valorTroco,
    this.desconto,
    this.usuario,
    this.mesa,
    this.comanda,
    this.status,
    this.dataPedido,
    this.dataAlteracao
  });

  Venda.fromJson(Map<String,dynamic> json){
    id = json['id'];
    cliente = json['cliente'];
    valorBruto = json['valorBruto'];
    valorLiquido = json['valorLiquido'];
    valorTroco = json['valorTroco'];
    mesa = json['mesa'];
    desconto = json['desconto'];
    status = json['status'];
    usuario = Usuario(id: json['usuario'], nome: json['nomeUsuario']);
    comanda = json['comanda'] == 'S' ? true : false;
    dataPedido = DateTime.parse(json['dataPedido']);
    dataAlteracao = DateTime.parse(json['dataAlteracao']);
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> json =  {};
    json['id'] = id;
    json['cliente'] = cliente;
    json['valorBruto'] = valorBruto;
    json['valorLiquido'] = valorLiquido;
    json['valorTroco'] = valorTroco;
    json['desconto'] = desconto;
    json['comanda'] = comanda == true ? "S" : "N";
    json['status'] = status;
    json['dataPedido'] = dataPedido.toString();
    json['mesa'] = mesa;
    json['usuario'] = Global().usuario!.id;
    json['nomeUsuario'] = Global().usuario!.nome;
    json['dataAlteracao'] = dataAlteracao.toString();
    return json;
  }
}