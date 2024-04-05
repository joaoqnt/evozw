import 'package:evoz_web/model/Produto.dart';

class ItemVenda{
  int? id;
  int? venda;
  Produto? produto;
  String? nomeProduto;
  int? quantidade;
  double? precoUnitario;
  double? preco;
  String? observacao;

  ItemVenda({
    this.id,
    this.venda,
    this.produto,
    this.nomeProduto,
    this.quantidade,
    this.preco,
    this.precoUnitario,
    this.observacao
  });

  ItemVenda.fromJson(Map<String,dynamic> json){
    id = json['id'];
    venda = json['venda'];
    quantidade = json['quantidade'];
    precoUnitario = json['precoUnitario'];
    nomeProduto = json['nomeProduto'];
    preco = json['preco'];
    observacao = json['observacao'];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = {};
    json['id'] = id;
    json['venda'] = venda;
    json['quantidade'] = quantidade;
    json['precoUnitario'] = precoUnitario;
    json['preco'] = preco;
    json['produto'] = produto!.id;
    json['nomeProduto'] = nomeProduto;
    json['observacao'] = observacao;
    return json;
  }
}