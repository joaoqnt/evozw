import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/Mesa.dart';
import 'package:evoz_web/repository/mesa_repository.dart';
import 'package:mobx/mobx.dart';

part 'mesa_controller.g.dart';

class MesaController = _MesaController with _$MesaController;

abstract class _MesaController with Store{
  final _repository = MesaRepository();
  final formKey = GlobalKey<FormState>();
  TextEditingController tecCodigo = TextEditingController();
  TextEditingController tecDescricao = TextEditingController();
  TextEditingController tecDataCriacao = TextEditingController();
  TextEditingController tecDataAbertura = TextEditingController();
  TextEditingController tecUltimaVenda = TextEditingController();
  TextEditingController tecValorTotal = TextEditingController();
  @observable
  List<Mesa> mesas = ObservableList.of([]);
  @observable
  int qtdMesa = 0;
  @observable
  bool isLoading = false;

  @action
  Future<List<Mesa>> getMesas() async{
    mesas = await _repository.getMesas();
    qtdMesa = mesas.length;
    return mesas;
  }

  @action
  Future createMesa() async{
    isLoading = true;
    Mesa mesa = Mesa(
        id: int.parse(tecCodigo.text),
        descricao: tecDescricao.text,
        statusOcupacao: "Disponível",
        dataCriacao: DateTime.now(),
        dataAbertura: DateTime(1966,4,24),
        ultimaVenda: DateTime(1966,4,24)
    );
    await _repository.insertMesa(mesa);
    getMesas();
    isLoading = false;
  }

  @action
  Future updateMesa(Mesa mesa) async{
    isLoading = true;
    mesa = Mesa(
        id: int.parse(tecCodigo.text),
        descricao: tecDescricao.text,
        statusOcupacao: mesa.statusOcupacao,
        dataCriacao: mesa.dataCriacao,
        dataAbertura: mesa.dataAbertura,
        ultimaVenda: mesa.ultimaVenda
    );
    await _repository.updateMesa(mesa);
    getMesas();
    isLoading = false;
  }

  @action
  Future deleteMesa(Mesa mesa) async{
    await _repository.deleteMesa(mesa);
    getMesas();
  }
}