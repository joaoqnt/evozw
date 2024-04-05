import 'dart:typed_data';

import 'package:evoz_web/model/Marca.dart';
import 'package:evoz_web/repository/marca_repository.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../service/upload_image.dart';
import '../util/global.dart';

part 'marca_controller.g.dart';

class MarcaController = _MarcaController with _$MarcaController;

abstract class _MarcaController with Store{
  final _repository = MarcaRepository();
  TextEditingController tecId = TextEditingController();
  TextEditingController tecNome = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @observable
  List<Marca> marcas = ObservableList.of([]);
  @observable
  Uint8List? bytesImageLogo;
  @observable
  bool isLoading = false;
  @observable
  int qtdMarcas = 0;

  @action
  createMarca() async{
    isLoading = true;
    Marca marca = Marca(
      nome: tecNome.text,
      urlLogo: bytesImageLogo != null
          ? "https://evozw.com.br/images/${Global().idEmpresa}/marca_${RemoveAcento()
            .removeAcentos(tecNome.text).replaceAll(' ', '_').toLowerCase()}.png"
          : null
    );
    await _repository.insertMarca(marca);
    bytesImageLogo != null ? await UploadImage().loadImage('marca_${tecNome.text}', bytesImageLogo!) : null;
    await getMarcas();
    isLoading = false;
  }

  @action
  updateMarca(Marca marca) async{
    isLoading = true;
    Marca tmp = Marca(
      id: marca.id,
        nome: tecNome.text,
        urlLogo: marca.urlLogo != null
            ? bytesImageLogo != null ? "https://evozw.com.br/images/${Global().idEmpresa}/marca_${RemoveAcento()
              .removeAcentos(tecNome.text).replaceAll(' ', '_').toLowerCase()}.png" : null
            : marca.urlLogo
    );
    await _repository.updateMarca(tmp);
    bytesImageLogo != null ? await UploadImage().loadImage('marca_${tecNome.text}', bytesImageLogo!) : null;
    await getMarcas();
    isLoading = false;
  }

  @action
  deleteMarca(Marca marca) async{
    await _repository.deleteMarca(marca);
    await getMarcas();
  }

  @action
  Future<List<Marca>> getMarcas() async{
    marcas = await _repository.getMarcas();
    qtdMarcas = marcas.length;
    bytesImageLogo = null;
    return marcas;
  }

  @action
  setImage(Uint8List bytes){
    bytesImageLogo = bytes;
  }
}