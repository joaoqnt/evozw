import 'package:dio/dio.dart';
import 'package:evoz_web/model/CaixaLog.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class CaixaLogRepository extends GenericRepository{

  Future<List<CaixaLog>> getCaixasLog(String dataInicial, String dataFinal) async{
    List<CaixaLog> caixas = [];
    Response response = await apiEvoz("caixaLogs?dataInicio=$dataInicial&dataFim=$dataFinal");
    var element = response.data;
    element.forEach((element){
      CaixaLog caixa = CaixaLog.fromJson(element);
      caixas.add(caixa);
    });
    return caixas;
  }
}