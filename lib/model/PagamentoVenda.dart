import 'package:evoz_web/model/Venda.dart';

class PagamentoVenda{
  int? id;
  int? venda;
  String? pagamento;
  String? bandeira;
  double? valor;
  double? valorTroco;

  PagamentoVenda({this.id,this.venda,this.pagamento,this.bandeira,this.valor,this.valorTroco});

  PagamentoVenda.fromJson(Map<String,dynamic> json){
    id = json['id'];
    pagamento = json['descricao'];
    bandeira = json['bandeira'];
    venda = json['venda'];
    valor = json['valorPagamento'];
    valorTroco = json['valorTroco'];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = {};
    json['id'] = id;
    json['descricao'] = pagamento;
    json['venda'] = venda;
    json['valorPagamento'] = valor;
    json['valorTroco'] = valorTroco;
    return json;
  }
}