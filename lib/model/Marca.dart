class Marca {
  int? id;
  String? nome;
  String? urlLogo;

  Marca({
    this.id,
    this.nome,
    this.urlLogo,
  });

  Marca.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    urlLogo = json['urlLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['urlLogo'] = this.urlLogo;
    return data;
  }
}