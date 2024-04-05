import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evoz_web/model/Usuario.dart';
import 'package:evoz_web/repository/generic_repository.dart';
import 'package:evoz_web/util/global.dart';

class UsuarioRepository extends GenericRepository{
  Future<bool> getUser(String? email, String senha) async{
    bool exists = false;
    String ip = "usuario?email=$email&senha=$senha";
    Response response = await apiEvoz(ip);
    if(response.statusCode == 200){
      try{
        var results = response.data;
        results.toString().isNotEmpty ? exists = true : exists = false;
        Global().usuario = Usuario.fromJson(results);
      }catch(e){

      }
    }
    return exists;
  }

  Future<Usuario?> getById(int id) async{
    var http = Dio();
    Usuario? usuario;
    String ip = "filterUser?id=$id";
    Response response = await apiEvoz(ip);
    if(response.statusCode == 200){
      try{
        var results = response.data;
        usuario = Usuario.fromJson(results);
      }catch(e){

      }
    }
    return usuario;
  }

  Future<List<Usuario>> getAll() async{
    List<Usuario> usuarios = [];
    try{
      Response response = await apiEvoz("usuarios");
      if(response.statusCode == 200){
        var results = response.data;
        results.forEach((element){
          Usuario usuario = Usuario.fromJson(element);
          usuarios.add(usuario);
        });
      }
    }catch(e){

    }
    return usuarios;
  }

  Future insertUsuario(Usuario usuario) async{
    String usuarioEncoded = jsonEncode(usuario.toJson());
    try{
      Response response = await apiEvoz("insert/usuario",post: true,data: usuarioEncoded);
    } catch(e){
      print("erro ao criar usuario $e");
    }
  }

  Future updateUsuario(Usuario usuario) async{
    String usuarioEncoded = jsonEncode(usuario.toJson());
    try{
      Response response = await apiEvoz("update/usuario",post: true,data: usuarioEncoded);
    } catch(e){
      print("erro ao alterar usuario $e");
    }
  }
}