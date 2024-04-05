class Config{
  int? id;
  int? usuario;
  String? perfil;
  bool? permCadCliente;
  bool? permCadProduto;
  bool? permVisRelator;
  bool? permVisVendas;

  Config({
    this.id,
    this.usuario,
    this.perfil,
    this.permCadCliente,
    this.permCadProduto,
    this.permVisRelator,
    this.permVisVendas
  });

  Config.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    perfil = json['perfil'];
    permCadCliente = json['permCadCliente'] == 'S' ? true : false;
    permCadProduto = json['permCadProduto'] == 'S' ? true : false;
    permVisRelator = json['permVisRelator'] == 'S' ? true : false;
    permVisVendas = json['permVisVendas'] == 'S' ? true : false;
  }

  Config administrador(int usuario){
    Config config = Config(
        id: 1,
        usuario: usuario,
        perfil: 'admin',
        permCadCliente: true,
        permCadProduto: true,
        permVisRelator: true,
        permVisVendas: true
    );
    return config;
  }

  Config balconista(int usuario){
    Config config = Config(
        id: 2,
        usuario: usuario,
        perfil: 'balconista',
        permCadCliente: false,
        permCadProduto: false,
        permVisRelator: false,
        permVisVendas: false
    );
    return config;
  }
}