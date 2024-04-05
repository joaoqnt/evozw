import 'dart:typed_data';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/model/Empresa.dart';
import 'package:evoz_web/repository/empresa_repository.dart';
import 'package:evoz_web/service/upload_image.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'loja_controller.g.dart';

class LojaController = _LojaController with _$LojaController;

abstract class _LojaController with Store{
  final _repository = EmpresaRepository();
  final formKey = GlobalKey<FormState>();
  TextEditingController tecEmpresa = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecInstagram = TextEditingController();
  TextEditingController tecFacebook = TextEditingController();
  TextEditingController tecWhatsApp = TextEditingController();
  TextEditingController tecDescricao = TextEditingController();
  @observable
  Uint8List? bytesImageLogo;
  @observable
  Uint8List? bytesImageBanner;
  @observable
  bool isLoading = false;
  @observable
  Color? colorMain;
  @observable
  Color? colorOnMain;

  @action
  setImageLogo(Uint8List? bytes){
    bytesImageLogo = bytes;
  }

  @action
  setImageBanner(Uint8List? bytes){
    bytesImageBanner = bytes;
  }

  loadData(){
    tecDescricao.text = Global().empresa!.descricao??'';
    tecFacebook.text = Global().empresa!.facebook??'';
    tecInstagram.text = Global().empresa!.instagram??'';
    tecWhatsApp.text = Global().empresa!.whatsapp??'';
    tecEmail.text = Global().empresa!.email??'';
    tecEmpresa.text = Global().empresa!.apelidoEmpresa??'';
  }

  @action
  saveEmpresa() async{
    isLoading = true;
    Empresa tmp = Global().empresa!;
    Empresa empresa = Empresa(
      id: tmp.id,
      descricao: tecDescricao.text,
      nome: tmp.nome,
      iLojaId: tmp.iLojaId,
      iCredentials: tmp.iCredentials,
      iClientSecret: tmp.iClientSecret,
      iClientId: tmp.iClientId,
      email: tecEmail.text,
      apelidoEmpresa: tecEmpresa.text,
      cnpj: tmp.cnpj,
      facebook: tecFacebook.text,
      instagram: tecInstagram.text,
      segmento: tmp.segmento,
      urlBanner: tmp.urlBanner != null && bytesImageBanner != null
          ? "https://evozw.com.br/images/${Global().idEmpresa}/banner.png"
          : tmp.urlBanner,
      urlLogo: tmp.urlLogo == null && bytesImageLogo != null
          ? "https://evozw.com.br/images/${Global().idEmpresa}/${Global().idEmpresa}.png"
          : tmp.urlLogo,
      urlLoja: "https://${Global().idEmpresa?.replaceAll('_', '')}.evozw.com.br",
      utilizaIfood: tmp.utilizaIfood,
      whatsapp: tecWhatsApp.text
    );
    bytesImageBanner != null ? await UploadImage().loadImage('banner', bytesImageBanner!) : null;
    bytesImageLogo != null ? await UploadImage().loadImage(Global().idEmpresa!, bytesImageLogo!) : null;
    await _repository.updateEmpresa(empresa);
    isLoading = false;
  }

  @action
  setColor(Color? colorVariable,Color color){
    colorVariable = color;
  }

}