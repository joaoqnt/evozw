import 'package:dio/dio.dart';

import '../model/Contato.dart';
import 'generic_repository.dart';

class ContatoRepository extends GenericRepository{
  Future<List<Contato>> getContatos() async{
    List<Contato> contatos = [];
    String ip = "contato";
    Response response = await apiEvoz(ip);
    List<dynamic> listTmp = response.data;
    listTmp.forEach((element) {
      Contato contato = Contato.fromJson(element);
      contatos.add(contato);
      print(element);
    });
    return contatos;
  }
}