import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/model/ItemVenda.dart';
import 'package:evoz_web/model/PagamentoVenda.dart';
import 'package:evoz_web/model/Venda.dart';
import 'package:evoz_web/repository/itemVenda_repository.dart';
import 'package:evoz_web/repository/pagamentoVenda_repository.dart';
import 'package:evoz_web/repository/venda_repository.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:mobx/mobx.dart';

part 'venda_controller.g.dart';

class VendaController = _VendaController with _$VendaController;

abstract class _VendaController with Store{
  final _repository = VendaRepository();
  final _pvRepository = PagamentoVendaRepository();
  final _ivRepository = ItemVendaRepository();
  TextEditingController tecPesquisa = TextEditingController();
  TextEditingController tecValLiq = TextEditingController();
  TextEditingController tecValBru = TextEditingController();
  TextEditingController tecValDes = TextEditingController();
  TextEditingController tecValTroco = TextEditingController();
  TextEditingController tecNomCli = TextEditingController();
  @observable
  List<Venda> vendas = ObservableList.of([]);
  @observable
  List<Venda> vendasFiltered = ObservableList.of([]);
  @observable
  List<PagamentoVenda> pagamentos = ObservableList.of([]);
  @observable
  List<ItemVenda> itens = ObservableList.of([]);
  @observable
  String? dtInicial;
  @observable
  String? dtFinal;
  @observable
  DateTime? _startDate;
  @observable
  DateTime? _endDate;
  @observable
  double valorTotal = 0;
  @observable
  double valorCredito = 0;
  @observable
  double valorDebito = 0;
  @observable
  double valorDinheiro = 0;
  @observable
  double valorPix = 0;
  @observable
  Map<Venda,bool> mapIsExpanded = ObservableMap.of({});
  @observable
  int pageSelected = 0;
  @observable
  Map<String,bool> mapFilterPagamento = ObservableMap.of({});

  Future<List<ItemVenda>> getVendas() async{
    dtInicial = FormatingDate.getDateToInsert(_startDate??DateTime.now(),data: true);
    dtFinal = FormatingDate.getDateToInsert(_endDate??DateTime.now(),data: true);
    vendas = await _repository.getVendas(dtInicial!,dtFinal!);
    List<int> ids = [];
    vendas.forEach((element) {
      ids.add(element.id!);
    });
    pagamentos = await _pvRepository.getPagamentoVendas(ids);
    itens = await _ivRepository.getItens(ids);
    vendas.forEach((element) {
      pagamentos.where((pgt) => pgt.venda == element.id).forEach((pgt) {
        element.pagamentos.add(pgt);
      });
      itens.where((item) => item.venda == element.id).forEach((item) {
        element.itens.add(item);
      });
    });
    vendasFiltered = vendas;
    vendasFiltered.sort((Venda a, Venda b) => b.dataPedido!.compareTo(a.dataPedido!));
    _getTotalFormaPgto();
    dtInicial = FormatingDate.getDate(_startDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    dtFinal = FormatingDate.getDate(_endDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    return itens;
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
      getVendas();
    }
  }

  _getTotalFormaPgto(){
    valorTotal = 0;
    valorDinheiro = 0;
    valorDebito = 0;
    valorCredito = 0;
    valorPix = 0;
    vendasFiltered.forEach((venda) {
      venda.pagamentos.forEach((element) {
        valorTotal += element.valor! - element.valorTroco!;
          element.pagamento == "Dinheiro" ? valorDinheiro += (element.valor! - element.valorTroco!) : null;
          element.pagamento == "Cartão de Crédito" ? valorCredito += element.valor! : null;
          element.pagamento == "Cartão de Débito" ? valorDebito += element.valor! : null;
          element.pagamento == "Pix" ? valorPix += element.valor! : null;
      });
    });
  }

  @action
  setExpanded(Venda venda){
    mapIsExpanded[venda] = !(mapIsExpanded[venda]??false);
  }

  @action
  setPage(int page){
    pageSelected = page;
  }

  @action
  filterVendaByPagamento(String pagamento){
    mapFilterPagamento[pagamento] = !(mapFilterPagamento[pagamento]??false);
    // print(mapFilterPagamento[pagamento]);
    vendasFiltered = vendas;
    Map<Venda,bool> containsPagamento = {};
    List<Venda> tmpVenda = [];
    bool isSomeSelected = false;
    //percorre cada venda
    vendasFiltered.forEach((element) {
      //percorre cada pagamento
      element.pagamentos.forEach((pgt) {
        mapFilterPagamento.forEach((key, value) {
          //se estiver filtrando
          if(value == true){
            isSomeSelected = value;
            if(pgt.pagamento?.toLowerCase() == key.toLowerCase()){
              containsPagamento[element] = true;
            }
            else{
              // containsPagamento[element] = false;
            }
          }
        });
      });
    });
    containsPagamento.forEach((key, value) {
      // print("${key.id} : $value");
      if(value == true){
        tmpVenda.add(key);
      }
    });
    // print(tmpVenda.length);
    isSomeSelected == true ? vendasFiltered = tmpVenda : null;
  }
}