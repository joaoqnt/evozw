import 'package:evoz_web/util/FormatDate.dart';

class Estoque{
  int? id;
  int? produto;
  String? nomeProduto;
  String? operacao;
  DateTime? dataAlteracao;
  String? usuario;
  int? estoqueAtual;

  Estoque({
    this.id,
    this.produto,
    this.nomeProduto,
    this.operacao,
    this.dataAlteracao,
    this.usuario,
    this.estoqueAtual,
  });

  Estoque.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produto = json['produto'];
    nomeProduto = json['nomeProduto'];
    operacao = json['operacao'];
    usuario = json['usuario'];
    estoqueAtual = json['estoqueAtual'];
    dataAlteracao = DateTime.parse(json['dataAlteracao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produto'] = this.produto;
    data['nomeProduto'] = this.nomeProduto;
    data['operacao'] = this.operacao;
    data['usuario'] = this.usuario;
    data['estoqueAtual'] = this.estoqueAtual;
    data['dataAlteracao'] = FormatingDate.getDate(this.dataAlteracao,FormatingDate.formatInsert);
    return data;
  }
}