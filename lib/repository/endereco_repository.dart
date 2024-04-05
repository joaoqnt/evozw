import 'package:dio/dio.dart';

class EnderecoRepository{
  Future<dynamic> getEndereco(String cep) async{
    int connectTimeout = 5000; // Tempo limite de conexão (5 segundos)
    int receiveTimeout = 3000; // Tempo limite de recebimento de dados (3 segundos)
    var http = Dio(
        BaseOptions(
            connectTimeout: Duration(milliseconds: connectTimeout),
            receiveTimeout:Duration(milliseconds: receiveTimeout)
        )
    );
    Response response = await http.get("https://viacep.com.br/ws/$cep/json/");
    return response.data;
  }
}