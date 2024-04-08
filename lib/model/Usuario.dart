class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;
  String? telefone;
  bool? ativo;
  String? perfil;
  DateTime? dataCadastro;
  bool? permCadCliente;
  bool? permAltCliente;
  bool? permCadProduto;
  bool? permAltProduto;
  bool? permVisRelator;
  bool? permVisVendas;
  bool? permContCaixa;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.telefone,
    this.ativo,
    this.perfil,
    this.dataCadastro,
    this.permCadCliente,
    this.permAltCliente,
    this.permCadProduto,
    this.permAltProduto,
    this.permVisRelator,
    this.permVisVendas,
    this.permContCaixa,
  });

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    telefone = json['telefone'];
    ativo = json['ativo'] == 'S' ? true : false;
    perfil = json['perfil'];
    dataCadastro = DateTime.parse(json['dataCadastro']);
    perfil = json['perfil'];
    permCadCliente = json['permCadCliente'] == 'S' ? true : false;
    permAltCliente = json['permAltCliente'] == 'S' ? true : false;
    permCadProduto = json['permCadProduto'] == 'S' ? true : false;
    permAltProduto = json['permAltProduto'] == 'S' ? true : false;
    permVisRelator = json['permVisRelator'] == 'S' ? true : false;
    permVisVendas = json['permVisVendas'] == 'S' ? true : false;
    permContCaixa = json['permContCaixa'] == 'S' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo == true ? 'S' : 'N';
    data['perfil'] = this.perfil;
    data['dataCadastro'] = this.dataCadastro.toString();
    data['permCadCliente'] = this.permCadCliente == true ? 'S' : 'N';
    data['permAltCliente'] = this.permAltCliente == true ? 'S' : 'N';
    data['permCadProduto'] = this.permCadProduto == true ? 'S' : 'N';
    data['permAltProduto'] = this.permAltProduto == true ? 'S' : 'N';
    data['permVisRelator'] = this.permVisRelator == true ? 'S' : 'N';
    data['permVisVendas'] = this.permVisVendas == true ? 'S' : 'N';
    data['permContCaixa'] = this.permContCaixa == true ? 'S' : 'N';
    return data;
  }
}
