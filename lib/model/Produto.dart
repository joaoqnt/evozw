import 'package:evoz_web/model/Marca.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/util/FormatDate.dart';

import 'ProdutoTamanho.dart';

class Produto {
  int? id;
  String? nome;
  double? preco;
  int? peso;
  int? estoque;
  bool? utilizaEstoque;
  bool? ativo;
  Categoria? categoria;
  DateTime? dataCriacao;
  DateTime? dataAlteracao;
  String? urlImage;
  List<ProdutoTamanho> tamanhos = [];
  Marca? marca;

  Produto({
    this.id,
    this.nome,
    this.preco,
    this.peso,
    this.estoque,
    this.utilizaEstoque,
    this.ativo,
    this.categoria,
    this.dataCriacao,
    this.dataAlteracao,
    this.urlImage,
    this.marca,
  });

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    preco = json['preco'];
    peso = json['peso'];
    estoque = json['estoque'];
    utilizaEstoque = json['utilizaEstoque'] == 'S' ? true : false;
    ativo = json['ativo'] == 'S' ? true : false;
    categoria?.id = json['categoria'];
    dataCriacao = DateTime.parse(json['dataCriacao']);
    dataAlteracao = DateTime.parse(json['dataAlteracao']);
    tamanhos = [];
    urlImage = json['urlImage'];
    marca?.id = json['marca'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['preco'] = this.preco;
    data['peso'] = this.peso;
    data['estoque'] = this.estoque;
    data['utilizaEstoque'] = this.utilizaEstoque??false ? 'S' : 'N';
    data['ativo'] = this.ativo??false ? 'S' : 'N';
    data['categoria'] = this.categoria?.id;
    data['dataCriacao'] = FormatingDate.getDate(this.dataCriacao,FormatingDate.formatInsert);
    data['dataAlteracao'] = FormatingDate.getDate(this.dataAlteracao,FormatingDate.formatInsert);
    data['urlImage'] = this.urlImage;
    data['marca'] = this.marca?.id;
    return data;
  }
}
