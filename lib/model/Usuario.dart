class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;
  String? telefone;
  bool? ativo;
  String? perfil;
  DateTime? dataCadastro;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.telefone,
    this.ativo,
    this.perfil,
    this.dataCadastro
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo.toString();
    data['perfil'] = this.perfil;
    data['dataCadastro'] = this.dataCadastro.toString();
    return data;
  }
}
