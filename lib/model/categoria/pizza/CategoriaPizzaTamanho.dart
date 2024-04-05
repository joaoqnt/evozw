import 'package:evoz_web/model/categoria/Categoria.dart';

class CategoriaPizzaTamanho{
  int? id;
  Categoria? categoria;
  String? nome;
  int? qtdPedacos;
  int? qtdSabores;

  CategoriaPizzaTamanho({
    this.id,
    this.categoria,
    this.nome,
    this.qtdPedacos,
    this.qtdSabores
  });

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nome'] = nome;
    data['qtdPedacos'] = qtdPedacos;
    data['qtdSabores'] = qtdSabores;
    return data;
  }

}