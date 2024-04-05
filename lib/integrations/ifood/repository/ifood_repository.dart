import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/util/global.dart';

class IfoodRepository{
  Future<Response> apiIfood(String url, Ifood ifood,{bool? post,Map<String,dynamic>? header}) async {
    String ip = 'http://localhost:8080/api/evozw_${Global().idEmpresa}/ifood/$url';
    Map<String, dynamic>? headers  = new Map();
    // header != null ? headers.addAll(header) : null;
    Global().iFood?.acessToken != null ? headers.addAll({"Authorization": "Bearer ${Global().iFood?.acessToken}"}) : null;
    String ifoodEncoded = jsonEncode(ifood.toJson());
    // print(ifood.toJson());
    print(ip);
    var http = Dio();
    post == true ? headers.addAll({HttpHeaders.contentTypeHeader: "application/json"}) : null;
    // print(data);
    try {
      Response response = (post == null || post == false)
          ? await http.get(ip, options: Options(headers: headers))
          : await http.post(ip, data: ifoodEncoded, options: Options(headers: headers));
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
}