class CaixaLog {
  int? usuario;
  String? descricao;
  DateTime? dataRegistro;

  CaixaLog({this.usuario, this.descricao, this.dataRegistro});

  CaixaLog.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    descricao = json['descricao'];
    dataRegistro = DateTime.parse(json['data_registro']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuario'] = this.usuario;
    data['descricao'] = this.descricao;
    data['data_registro'] = this.dataRegistro.toString();
    return data;
  }
}
