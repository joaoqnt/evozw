import 'package:evoz_web/util/FormatDate.dart';

class Contato {
  int? id;
  String? nome;
  String? telefone;
  DateTime? ultima_msg;

  Contato({this.id, this.nome, this.telefone});

  Contato.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ultima_msg = DateTime.parse(json['ultima_msg']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['ultima_msg'] =  FormatingDate.getDate(this.ultima_msg,FormatingDate.formatInsert);
    return data;
  }
}
