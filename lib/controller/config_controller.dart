import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/Config.dart';
import 'package:evoz_web/model/Usuario.dart';
import 'package:evoz_web/repository/usuario_repository.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/criptography.dart';
import 'package:mobx/mobx.dart';

part 'config_controller.g.dart';

class ConfigController = _ConfigController with _$ConfigController;

abstract class _ConfigController with Store{
  final _repository = UsuarioRepository();
  final formKey = GlobalKey<FormState>();
  TextEditingController tecId = TextEditingController(text: "Automatico");
  TextEditingController tecNome = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecTelefone = TextEditingController();
  TextEditingController tecDataRegistro = TextEditingController();
  TextEditingController tecSenha = TextEditingController();
  @observable
  List<Usuario> usuarios = ObservableList.of([]);
  @observable
  Config? perfilSelected;
  @observable
  int pageSelected = 0;
  @observable
  List<Config> perfis = [];
  @observable
  bool hidePassword = true;
  @observable
  bool isLoading = false;

  @action
  Future<List<Usuario>> getUsuarios () async{
    usuarios = await _repository.getAll();
    usuarios.sort((Usuario a, Usuario b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
    _loadPerfis();
    return usuarios;
  }

  @action
  createUsuario() async{
    isLoading = true;
    Usuario usuario = Usuario(
        perfil: (perfilSelected?.perfil??"balconista"),
        telefone: UtilBrasilFields.removeCaracteres(tecTelefone.text),
        email: tecEmail.text.toLowerCase(),
        nome: tecNome.text,
        senha:tecSenha.text,// Criptography().encryptPassword(tecSenha.text),
        dataCadastro: DateTime.now(),
        ativo: true
    );
    await _repository.insertUsuario(usuario);
    await getUsuarios();
    isLoading = false;
  }

  @action
  updateUsuario(Usuario usuario) async{
    isLoading = true;
    usuario = Usuario(
        id: usuario.id,
        perfil: (perfilSelected?.perfil??"balconista"),
        telefone: UtilBrasilFields.removeCaracteres(tecTelefone.text),
        email: tecEmail.text,
        nome: tecNome.text,
        senha: tecSenha.text,//Criptography().encryptPassword(tecSenha.text),
        dataCadastro: usuario.dataCadastro,
        ativo: true
    );
    await _repository.updateUsuario(usuario);
    await getUsuarios();
    isLoading = false;
  }

  @action
  setPage(int page) {
    pageSelected = page;
  }



  @action
  setPerfil(Config perfil){
    perfilSelected = perfil;
    // print(perfilSelected?.perfil);
  }

  _loadPerfis(){
    perfis = [];
    Config adm = Config().administrador(0);
    Config bal = Config().balconista(0);
    perfis.add(adm);
    perfis.add(bal);
  }

  @action
  showPassword(){
    hidePassword = !hidePassword;
  }
}