import 'dart:typed_data';

import 'package:evoz_web/repository/generic_repository.dart';

class UploadImage{
  final _repository = GenericRepository();
  Future loadImage(String text, Uint8List bytes) async{
    await _repository.uploadImage(text, bytes);
  }
}