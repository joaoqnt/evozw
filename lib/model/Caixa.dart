import 'package:evoz_web/model/Usuario.dart';
import 'package:evoz_web/util/FormatDate.dart';

class Caixa {
  int? id;
  bool? ativo;
  double? valorInicial;
  double? valorAtual;
  Usuario? usuario;
  DateTime? dataInicio;
  DateTime? dataFim;
  DateTime? dataAlteracao;

  Caixa({
    this.id,
    this.ativo,
    this.valorInicial,
    this.valorAtual,
    this.usuario,
    this.dataInicio,
    this.dataFim,
    this.dataAlteracao,
  });

  Caixa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ativo = json['ativo'] == 'S' ? true : false;
    valorInicial = json['valorInicial'];
    valorAtual = json['valorAtual'];
    usuario?.id = json['usuario'];
    dataInicio = json['dataInicio'] != null
        ? DateTime.parse(json['dataInicio'])
        : null;
    dataFim =
    json['dataFim'] != null ? DateTime.parse(json['dataFim']) : null;
    json['dataAlteracao'] != null ? DateTime.parse(json['dataAlteracao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ativo'] = this.ativo == true ? 'S' : 'N';
    data['valorInicial'] = this.valorInicial;
    data['valorAtual'] = this.valorAtual;
    data['usuario'] = this.usuario?.id;
    data['dataInicio'] = FormatingDate.getDate(this.dataInicio,FormatingDate.formatInsert);
    try{
      data['dataFim'] = FormatingDate.getDate(this.dataFim,FormatingDate.formatInsert);
    } catch(e){

    }
    data['dataAlteracao'] = FormatingDate.getDate(this.dataAlteracao,FormatingDate.formatInsert);
    return data;
  }
}