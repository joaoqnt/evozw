class Ifood{
  String? iCredentials;
  String? iClientId;
  String? iClientSecret;
  String? iLojaId;
  String? acessToken;
  DateTime? tokenDate;
  String? merchantId;
  String? merchantName;
  String? merchantCorporateName;
  String? merchantStatus;

  Ifood({this.iCredentials, this.iClientId, this.iClientSecret, this.iLojaId});

  Ifood.fromJson(Map<String,dynamic> json){
    iCredentials = iCredentials;
    iClientId = iClientId;
    iClientSecret = iClientSecret;
    iLojaId = iLojaId;
    acessToken = acessToken;
    tokenDate = tokenDate;
    merchantId = json["id"];
    merchantName = json["name"];
    merchantCorporateName = json["corporateName"];
    merchantStatus = json["status"];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grantType'] = this.iCredentials;
    data['clientId'] = this.iClientId;
    data['clientSecret'] = this.iClientSecret;
    data['iLojaId'] = this.iLojaId;
    data['acessToken'] = this.acessToken;
    data['tokenDate'] = tokenDate;
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantCorporateName'] = merchantCorporateName;
    data['merchantStatus'] = merchantStatus;
    return data;
  }
}