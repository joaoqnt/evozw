import 'package:encrypt/encrypt.dart';

class Criptography{
  final key = Key.fromLength(32);
  final iv = IV.fromLength(16);

  // String encryptPassword(String password) {
  //   final encrypter = Encrypter(AES(key));
  //   final encrypted = encrypter.encrypt(password, iv: iv);
  //   return encrypted.base64;
  // }
  //
  // String decryptPassword(String encryptedPassword) {
  //   final encrypter = Encrypter(AES(key));
  //   final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
  //   return decrypted;
  // }
}