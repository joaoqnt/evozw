class ProdutoTamanho{
  int? id;
  int? produto;
  String? tamanho;
  int? quantidade;

  ProdutoTamanho({this.id,this.produto,this.tamanho,this.quantidade});

  ProdutoTamanho.fromJson(Map<String,dynamic> json){
    id = json['id'];
    produto = json['produto'];
    tamanho = json['tamanho'];
    quantidade = json['quantidade'];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['produto'] = produto;
    data['tamanho'] = tamanho;
    data['quantidade'] = quantidade;
    return data;
  }
}