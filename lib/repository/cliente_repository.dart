import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Cliente.dart';
import 'package:evoz_web/repository/generic_repository.dart';

class ClienteRepository extends GenericRepository{

  Future<List<Cliente>> getClientes() async{
    List<Cliente> clientes = [];
    try{
      Response response = await apiEvoz("cliente");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Cliente cliente = Cliente.fromJson(element);
          clientes.add(cliente);
        });
      }
    }catch(e){

    }
    return clientes;
  }

  Future insertCliente (Cliente cliente) async{
    String clienteEncoded = jsonEncode(cliente.toJson());
    try{
      Response response = await apiEvoz("insert/cliente",post: true,data: clienteEncoded);
    } catch(e){

    }
  }

  Future updateCliente (Cliente cliente) async{
    String clienteEncoded = jsonEncode(cliente.toJson());
    try{
      Response response = await apiEvoz("update/cliente",post: true,data: clienteEncoded);
    } catch(e){

    }
  }

  Future deleteCliente (Cliente cliente) async{
    String clienteEncoded = jsonEncode(cliente.toJson());
    try{
      Response response = await apiEvoz("delete/cliente",post: true,data: clienteEncoded);
    } catch(e){

    }
  }
}