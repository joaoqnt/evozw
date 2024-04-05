import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/Cliente.dart';
import 'package:evoz_web/repository/cliente_repository.dart';
import 'package:evoz_web/repository/endereco_repository.dart';
import 'package:mobx/mobx.dart';

part 'cliente_controller.g.dart';

class ClienteController = _ClienteController with _$ClienteController;

abstract class _ClienteController with Store{
  final _eRepository = EnderecoRepository();
  final _repository = ClienteRepository();
  TextEditingController tecId = TextEditingController(text: "Automatico");
  TextEditingController tecNome = TextEditingController();
  TextEditingController tecCpf = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecTelefone = TextEditingController();
  TextEditingController tecDataNasc = TextEditingController();
  TextEditingController tecCep = TextEditingController();
  TextEditingController tecCidade = TextEditingController();
  TextEditingController tecUf = TextEditingController();
  TextEditingController tecBairro = TextEditingController();
  TextEditingController tecRua = TextEditingController();
  TextEditingController tecNumero = TextEditingController();
  TextEditingController tecBusca = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @observable
  List<Cliente> clientes = ObservableList.of([]);
  @observable
  int qtdClientes = 0;
  @observable
  bool isLoading = false;

  @action
  Future<List<Cliente>> getClientes() async{
    clientes = await _repository.getClientes();
    qtdClientes = clientes.length;
    clientes.sort((Cliente a, Cliente b) => a.nome!.compareTo(b.nome!));
    return clientes;
  }

  Future createCliente() async{
    isLoading = true;
    Cliente cliente = Cliente(
        nome: tecNome.text,
        bairro: tecBairro.text,
        cep: UtilBrasilFields.removeCaracteres(tecCep.text),
        cidade: tecCidade.text,
        cpf: UtilBrasilFields.removeCaracteres(tecCpf.text),
        dataNascimento: getDate(),
        email: tecEmail.text,
        numero: int.parse(tecNumero.text),
        rua: tecRua.text,
        telefone: UtilBrasilFields.removeCaracteres(tecTelefone.text),
        uf: tecUf.text
    );
    await _repository.insertCliente(cliente);
    await getClientes();
    isLoading = false;
  }

  Future updateCliente(Cliente cliente) async{
    isLoading = true;
    cliente = Cliente(
        id: cliente.id,
        nome: tecNome.text,
        bairro: tecBairro.text,
        cep: UtilBrasilFields.removeCaracteres(tecCep.text),
        cidade: tecCidade.text,
        cpf: UtilBrasilFields.removeCaracteres(tecCpf.text),
        dataNascimento: getDate(),
        email: tecEmail.text,
        numero: int.parse(tecNumero.text),
        rua: tecRua.text,
        telefone: UtilBrasilFields.removeCaracteres(tecTelefone.text),
        uf: tecUf.text
    );
    await _repository.updateCliente(cliente);
    await getClientes();
  }

  Future deleteCliente(Cliente cliente) async{
    await _repository.deleteCliente(cliente);
    await getClientes();
  }

  Future getEndereco() async {
    try{
      var element = await _eRepository.getEndereco(UtilBrasilFields.removeCaracteres(tecCep.text));
      tecCidade.text = element['localidade'];
      tecUf.text = element['uf'];
      tecBairro.text = element['bairro'];
      tecRua.text = element['logradouro'];
      // print(tecCidade.text);
    } catch(e){
      print(e);
    }
  }

  DateTime getDate(){
    int day = int.parse(tecDataNasc.text.substring(0,2));
    int month = int.parse(tecDataNasc.text.substring(3,5));
    int year = int.parse(tecDataNasc.text.substring(6,10));
    DateTime dataNascimento = DateTime(year,month,day);
    return dataNascimento;
  }
}