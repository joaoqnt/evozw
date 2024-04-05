import 'package:evoz_web/model/categoria/pizza/CategoriaPizza.dart';

class Categoria {
  int? id;
  String? nome;
  bool? ativo;
  String? layout;
  CategoriaPizza? pizza;

  Categoria({this.id, this.nome, this.ativo});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    ativo = json['ativo'] == 'S' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['ativo'] = this.ativo == true ? 'S' : 'N';
    data['pizza'] = pizza;
    return data;
  }
}
