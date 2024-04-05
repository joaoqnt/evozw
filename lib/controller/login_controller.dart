import 'package:evoz_web/integrations/ifood/Ifood.dart';
import 'package:evoz_web/integrations/ifood/repository/authentication/authentication_repository.dart';
import 'package:evoz_web/integrations/ifood/repository/merchant/merchants_repository.dart';
import 'package:evoz_web/model/Empresa.dart';
import 'package:evoz_web/repository/empresa_repository.dart';
import 'package:evoz_web/util/criptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/repository/usuario_repository.dart';
import 'package:evoz_web/util/global.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_controller.g.dart';

class LoginController = _LoginController with _$LoginController;

abstract class _LoginController with Store{
  TextEditingController tecUser = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecIdEmpresa = TextEditingController();
  final _aRepository = AuthenticationRepository();
  final _mRepository = MerchantRepository();
  UsuarioRepository _repository = UsuarioRepository();
  final _eRepository = EmpresaRepository();
  final formKey = GlobalKey<FormState>();
  SharedPreferences? sp;
  FocusNode focusNode = FocusNode();
  @observable
  bool loading = false;
  @observable
  bool visibilyPassword = false;

  Future<String> loadDataLogin() async{
    // print("fez");
    if(tecUser.text.isEmpty){
      sp = await SharedPreferences.getInstance();
      tecUser.text = sp!.getString("username")??'';
      tecPassword.text = sp!.getString("password")??'';
      tecIdEmpresa.text = sp!.getString("id")??'';
    }
    return "completo";
  }

  @action
  Future<bool> doLogin(String user, String password) async{
    Global().idEmpresa = tecIdEmpresa.text;
    loading = true;
    bool exists = false;
    // print(password);
    try{
      exists = await _repository.getUser(user,password);
      if(exists){
        Empresa? empresa = await _eRepository.getEmpresa();
        Global().empresa = empresa!;
        // if(empresa?.iClientId != null && empresa?.utilizaIfood == true){
        //   Global().iFood = Ifood(
        //       iClientId: empresa?.iClientId,
        //       iClientSecret: empresa?.iClientSecret,
        //       iCredentials: empresa?.iCredentials,
        //       iLojaId: empresa?.iLojaId
        //   );
        //   await _aRepository.getAcessToken();
        //   await _loadMerchant();
        // }
      }
      // print(Global().usuario?.toJson());
    }catch(e){
      print(e);
    }
    sp!.setString("username", tecUser.text.toLowerCase());
    sp!.setString("password", tecPassword.text.toLowerCase());
    sp!.setString("id", tecIdEmpresa.text.toLowerCase());
    loading = false;
    return exists;
  }

  @action
  showPassword(){
    visibilyPassword = !visibilyPassword;
  }

  // _loadMerchant() async{
  //   await _mRepository.getMerchants();
  // }
}