import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:evoz_web/repository/formaPgto_repository.dart';
import 'package:mobx/mobx.dart';

part 'pagamento_controller.g.dart';

class PagamentoController = _PagamentoController with _$PagamentoController;

abstract class _PagamentoController with Store{
  final repository = FormaPgtoRepository();
  TextEditingController tecId = TextEditingController(text: "Gerado automaticamente");
  TextEditingController tecDescricao = TextEditingController();
  TextEditingController tecValorMinimo = TextEditingController();
  TextEditingController tecDtCriacao = TextEditingController();
  TextEditingController tecDtAlteracao = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @observable
  List<FormaPagamento> formas = ObservableList.of([]);
  @observable
  bool ativo = true;
  @observable
  bool utilizaValMin = false;
  @observable
  bool isLoading = false;

  @action
  Future getFormas() async{
    formas = await repository.getFormas();
  }

  @action
  Future insertProduto() async{
    isLoading = true;
    FormaPagamento forma = FormaPagamento(
        descricao: tecDescricao.text,
        valorMin: UtilBrasilFields.converterMoedaParaDouble(tecValorMinimo.text.isEmpty ? "0" : tecValorMinimo.text),
        ativo: ativo,
        dataCriacao: DateTime.now(),
        dataAlteracao: DateTime.now()
    );
    await repository.insertForma(forma);
    await getFormas();
    isLoading = false;
  }

  @action
  setUtilizaValMin(){
    utilizaValMin = !utilizaValMin;
  }

  @action
  setAtivo(){
    ativo = !ativo;
  }
}