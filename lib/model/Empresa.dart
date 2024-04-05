import 'package:evoz_web/model/segmento.dart';

class Empresa {
  int? id;
  String? nome;
  String? cnpj;
  Segmento? segmento;
  String? iCredentials;
  String? iClientId;
  String? iClientSecret;
  String? iLojaId;
  bool? utilizaIfood;
  String? apelidoEmpresa;
  String? email;
  String? instagram;
  String? whatsapp;
  String? facebook;
  String? descricao;
  String? urlLogo;
  String? urlBanner;
  String? urlLoja;

  Empresa({
    this.id,
    this.nome,
    this.cnpj,
    this.segmento,
    this.iCredentials,
    this.iClientId,
    this.iClientSecret,
    this.iLojaId,
    this.utilizaIfood,
    this.apelidoEmpresa,
    this.email,
    this.instagram,
    this.whatsapp,
    this.facebook,
    this.descricao,
    this.urlLogo,
    this.urlBanner,
    this.urlLoja,
  });

  Empresa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    segmento = Segmento(json['segmento']);
    cnpj = json['cnpj'];
    iCredentials = json['iCredentials'];
    iClientId = json['iClientId'];
    iClientSecret = json['iClientSecret'];
    iLojaId = json['iLojaId'];
    utilizaIfood = json['utilizaIfood'] == 'S' ? true : false;
    apelidoEmpresa = json['apelidoEmpresa'];
    email = json['email'];
    instagram = json['instagram'];
    whatsapp = json['whatsApp'];
    facebook = json['facebook'];
    descricao = json['descricao'];
    urlLogo = json['urlLogo'];
    urlBanner = json['urlBanner'];
    urlLoja = json['urlLoja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nome'] = nome;
    data['segmento'] = segmento?.nome;
    data['cnpj'] = cnpj;
    data['iCredentials'] = iCredentials;
    data['iClientId'] = iClientId;
    data['iClientSecret'] = iClientSecret;
    data['iLojaId'] = iLojaId;
    data['utilizaIfood'] = utilizaIfood == true ? "S" : "N";
    data['apelidoEmpresa'] = apelidoEmpresa;
    data['email'] = email;
    data['instagram'] = instagram;
    data['whatsApp'] = whatsapp;
    data['facebook'] = facebook;
    data['descricao'] = descricao;
    data['urlLogo'] = urlLogo;
    data['urlBanner'] = urlBanner;
    data['urlLoja'] = urlLoja;
    return data;
  }
}