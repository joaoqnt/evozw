import 'package:evoz_web/model/CaixaLog.dart';
import 'package:evoz_web/repository/caixaLog_repository.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'caixa_controller.g.dart';

class CaixaController = _CaixaController with _$CaixaController;

abstract class _CaixaController with Store{
  final _repository = CaixaLogRepository();
  @observable
  List<CaixaLog> caixas = ObservableList.of([]);
  @observable
  String? dtInicial;
  @observable
  String? dtFinal;
  @observable
  DateTime? _startDate;
  @observable
  DateTime? _endDate;

  @action
  Future<List<CaixaLog>> getCaixas() async{
    dtInicial = FormatingDate.getDateToInsert(_startDate??DateTime.now(),data: true);
    dtFinal = FormatingDate.getDateToInsert(_endDate??DateTime.now(),data: true);
    caixas = await _repository.getCaixasLog(dtInicial!, dtFinal!);
    caixas.sort((CaixaLog a, CaixaLog b) => b.dataRegistro!.compareTo(a.dataRegistro!));
    dtInicial = FormatingDate.getDate(_startDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    dtFinal = FormatingDate.getDate(_endDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    return caixas;
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
      getCaixas();
    }
  }
}