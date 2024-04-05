
import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/model/Empresa.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/model/Caixa.dart';
import 'package:evoz_web/model/Usuario.dart';

class Global{

  static Global? _instance;

  factory Global(){
    _instance ??= Global._internalConstructor();
    return _instance!;
  }

  Global._internalConstructor();

  Usuario? usuario;
  Ifood? iFood;
  String? idEmpresa;
  Empresa? empresa;
  bool? logado;

}