import 'package:dio/dio.dart';
import 'package:evoz_web/integrations/ifood/repository/ifood_repository.dart';
import 'package:evoz_web/util/global.dart';

class AuthenticationRepository extends IfoodRepository{
  Future<String> getAcessToken() async{
    String token = '';
    Response response = await apiIfood('authentication',Global().iFood!,post: true);
    Global().iFood?.acessToken = response.data;
    // Global().iFood?.tokenDate = DateTime.now();
    return token;
  }
}