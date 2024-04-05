class FormaPagamento{
  int? id;
  String? descricao;
  bool? utilizaValorMin;
  double? valorMin;
  DateTime? dataCriacao;
  DateTime? dataAlteracao;
  bool? ativo;
  bool? utilizaBandeira;
  List<String> bandeiras = [];

  FormaPagamento({
    this.id,
    this.descricao,
    this.utilizaValorMin,
    this.valorMin,
    this.dataCriacao,
    this.dataAlteracao,
    this.ativo,
    this.utilizaBandeira
  });

  FormaPagamento.fromJson(Map<String,dynamic> json){
    id = json['id'];
    descricao = json['descricao'];
    utilizaValorMin = json['utilizaValorMinimo'] == 'S' ? true : false;
    valorMin = json['valorMinimo'];
    dataCriacao = DateTime.parse(json['dataCriacao']);
    dataAlteracao = DateTime.parse(json['dataAlteracao']);
    ativo = json['ativo'] == 'S' ? true : false;
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = {};
    json['id'] = id;
    json['descricao'] = descricao;
    json['utilizaValorMinimo'] = utilizaValorMin == true ? 'S' : 'N';
    json['valorMinimo'] = valorMin;
    json['dataCriacao'] = dataCriacao.toString();
    json['dataAlteracao'] = dataAlteracao.toString();
    json['ativo'] = ativo == true ? 'S' : 'N';
    return json;
  }
}