import 'package:evoz_web/util/FormatDate.dart';

class Cliente {
  int? id;
  String? nome;
  String? cpf;
  DateTime? dataNascimento;
  String? email;
  String? telefone;
  String? cep;
  String? cidade;
  String? uf;
  String? bairro;
  String? rua;
  String? complemento;
  int? numero;

  Cliente(
      {this.id,
        this.nome,
        this.cpf,
        this.dataNascimento,
        this.email,
        this.telefone,
        this.cep,
        this.cidade,
        this.uf,
        this.bairro,
        this.rua,
        this.complemento,
        this.numero});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    dataNascimento = DateTime.parse(json['dataNascimento']);
    email = json['email'];
    telefone = json['telefone'];
    cep = json['cep'];
    cidade = json['cidade'];
    uf = json['uf'];
    bairro = json['bairro'];
    rua = json['rua'];
    complemento = json['complemento'];
    numero = json['numero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['dataNascimento'] = FormatingDate.getDate(this.dataNascimento,FormatingDate.formatInsert);
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    data['cep'] = this.cep;
    data['cidade'] = this.cidade;
    data['uf'] = this.uf;
    data['bairro'] = this.bairro;
    data['rua'] = this.rua;
    data['complemento'] = this.complemento;
    data['numero'] = this.numero;
    return data;
  }
}
