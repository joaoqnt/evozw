import 'package:evoz_web/model/ItemCombo.dart';

class CabCombo{
  int? id;
  String? descricao;
  double? valorTotal;
  double? descontoTotal;
  DateTime? dataCriacao;
  DateTime? dataAlteracao;
  List<ItemCombo> itens = [];
  bool? ativo;


  CabCombo({
    this.id,
    this.descricao,
    this.valorTotal,
    this.descontoTotal,
    this.dataCriacao,
    this.dataAlteracao,
    this.ativo
  });

  CabCombo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ativo = json['ativo'] == 'S' ? true : false;
    descricao = json['descricao'];
    valorTotal = json['valorTotal'];
    descontoTotal = json['descontoTotal'];
    dataCriacao = DateTime.parse(json['dataCriacao']);
    dataAlteracao = DateTime.parse(json['dataAlteracao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ativo'] = this.ativo == true ? 'S' : 'N';
    data['descricao'] = this.descricao;
    data['valorTotal'] = this.valorTotal;
    data['descontoTotal'] = this.descontoTotal;
    data['dataCriacao'] = this.dataCriacao.toString();
    data['dataAlteracao'] = this.dataAlteracao.toString();
    return data;
  }

}