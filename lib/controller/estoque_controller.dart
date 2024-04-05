import 'package:evoz_web/model/Estoque.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/repository/estoque_repository.dart';
import 'package:evoz_web/repository/produto_repository.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'estoque_controller.g.dart';

class EstoqueController = _EstoqueController with _$EstoqueController;

abstract class _EstoqueController with Store{
  final _eRepository = EstoqueRepository();
  final _pRepository = ProdutoRepository();
  TextEditingController tecPesquisa = TextEditingController();
  List<Estoque> estoques = ObservableList.of([]);
  @observable
  List<Estoque> estoquesFiltered = ObservableList.of([]);
  @observable
  List<Produto> produtos = ObservableList.of([]);
  @observable
  String? dtInicial;
  @observable
  String? dtFinal;
  @observable
  DateTime? _startDate;
  @observable
  DateTime? _endDate;

  @action
  Future<List<Estoque>> getEstoques() async{
    dtInicial = FormatingDate.getDateToInsert(_startDate??DateTime.now(),data: true);
    dtFinal = FormatingDate.getDateToInsert(_endDate??DateTime.now(),data: true);
    // print(dtInicial);
    estoques = await _eRepository.getEstoque(dtInicial!,dtFinal!);
    produtos = await _pRepository.getProdutos();
    estoques.sort((Estoque a, Estoque b) => b.dataAlteracao!.compareTo(a.dataAlteracao!));
    estoquesFiltered = estoques;
    dtInicial = FormatingDate.getDate(_startDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    dtFinal = FormatingDate.getDate(_endDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    // _setProdutoEstoque();
    return estoques;
  }

  @action
  Future setDateIni(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now() ,
        firstDate: DateTime(2023),
        lastDate: DateTime.now(),
        helpText: "De"
    );
    if (picked != null) {
      _startDate = picked;
      _startDate = DateTime(_startDate!.year,_startDate!.month,_startDate!.day,00,00,00,00);
      await _setDateFim(context);
    }
  }

  @action
  Future _setDateFim(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now() ,
        firstDate: _startDate!,
        lastDate: DateTime.now(),
        helpText: "Até"
    );
    if (picked != null) {
      _endDate = picked;
      _endDate = DateTime(_endDate!.year,_endDate!.month,_endDate!.day,23,59,59);
      await getEstoques();
    }
  }

  // _setProdutoEstoque(){
  //   produtos.forEach((produto) {
  //     estoquesFiltered.where((estoque) => estoque.produto == produto.id).forEach((element) {
  //       element.estoqueAtual = produto.estoque;
  //     });
  //   });
  // }

  @action
  filter(){
    estoquesFiltered = estoques.where(
            (element) => RemoveAcento().removeAcentos(element.nomeProduto!.toLowerCase()).
            contains(RemoveAcento().removeAcentos(tecPesquisa.text.toLowerCase()))
    ).toList();
  }
}