import 'package:evoz_web/model/CabCombo.dart';
import 'package:evoz_web/model/Produto.dart';

class ItemCombo {
  CabCombo? combo;
  int? id;
  Produto? produto;
  int? quantidade;
  double? preco;

  ItemCombo({this.combo,this.id, this.produto, this.quantidade, this.preco});

  ItemCombo.fromJson(Map<String, dynamic> json) {
    combo = CabCombo(id: json['combo']);
    id = json['id'];
    produto = Produto(id: json['produto']);
    quantidade = json['quantidade'];
    preco = json['preco'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['combo'] = this.combo?.id;
    data['id'] = this.id;
    data['produto'] = this.produto?.id;
    data['quantidade'] = this.quantidade;
    data['preco'] = this.preco;
    return data;
  }
}
