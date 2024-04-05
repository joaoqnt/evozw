import 'package:flutter/material.dart';

class Segmento{
  String? nome;
  IconData? icone;
  bool? utilizaPizza;
  bool? utilizaTamanho;
  bool? utilizaQtdTamanho;

  Segmento(this.nome){
    switch(nome!.toLowerCase()){
      case "lanchonete":{
        icone = Icons.lunch_dining_outlined;
        utilizaPizza = false;
        break;
      }
      case "pizzaria":{
        icone = Icons.local_pizza_outlined;
        utilizaPizza = true;
        break;
      }
      case "barbearia":{
        icone = Icons.cut;
        utilizaPizza = false;
        break;
      }
      case "rouparia":{
        icone = Icons.checkroom_outlined;
        utilizaPizza = false;
        utilizaTamanho = true;
        utilizaQtdTamanho = true;
        break;
      }
      case "mecanica":{
        icone = Icons.plumbing_outlined;
        utilizaPizza = false;
        break;
      }
      default:{
        icone = Icons.splitscreen_outlined;
        utilizaPizza = false;
        break;
      }
    }
  }
}