import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:evoz_web/util/global.dart';

class GenericRepository{

  Future<Response> apiEvoz(String url, {bool? post, Map<String, dynamic>? map, dynamic data}) async {
    String ip = "https://api.evozw.com.br/api/evozw_${Global().idEmpresa}/$url";
    // String ip = "http://joaoqnt.ddns.net:8080/api/evozw_${Global().idEmpresa}/$url";
    // String ip = "http://localhost:8080/api/evozw_${Global().idEmpresa}/$url";
    Map<String, dynamic>? headers  = new Map();
    print(ip);
    int connectTimeout = 10000; // Tempo limite de conexão (5 segundos)
    int receiveTimeout = 6000; // Tempo limite de recebimento de dados (3 segundos)
    var http = Dio(
        BaseOptions(
          connectTimeout: Duration(milliseconds: connectTimeout),
            receiveTimeout:Duration(milliseconds: receiveTimeout)
        )
    );
    post == true ? headers.addAll({HttpHeaders.contentTypeHeader: "application/json"}) : null;

    try {
      Response response = post == null || post == false
          ? await http.get(ip, options: Options(headers: headers))
          : await http.post(ip, data: data, options: Options(headers: headers));
      return response;
    } catch (error) {
      print("Erro na requisição:  $error");
      return Response(
          data: {"error": "Ocorreu um erro na requisição"},
          statusCode: 500,
          requestOptions: RequestOptions()
      );
    }
  }

  Future uploadImage(String text, Uint8List bytes) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
          bytes,
          filename: "${RemoveAcento().removeAcentos(text).replaceAll(' ', '_').toLowerCase()}.png"
      ),
      'nomeEmpresa': Global().idEmpresa, // Se necessário, inclua outros parâmetros
    });

    try {
      Response response = await dio.post('https://api.evozw.com.br/api/evozw_${Global().idEmpresa}/upload', data: formData);
      print('Response: ${response.data}');
    } catch (e) {
      print('Erro durante o upload: $e');
    }
  }
}