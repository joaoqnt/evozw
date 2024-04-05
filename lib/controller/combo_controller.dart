import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/model/CabCombo.dart';
import 'package:evoz_web/repository/itemCombo_repository.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/ItemCombo.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/repository/produto_repository.dart';
import 'package:mobx/mobx.dart';

import '../repository/combo_repository.dart';

part 'combo_controller.g.dart';

class ComboController = _ComboController with _$ComboController;

abstract class _ComboController with Store{
  final _pRepository = ProdutoRepository();
  final _repository = ComboRepository();
  final _iRepository = ItemComboRepository();
  final formKey = GlobalKey<FormState>();
  TextEditingController tecId =  TextEditingController();
  TextEditingController tecNome =  TextEditingController();
  TextEditingController tecPreco =  TextEditingController();
  TextEditingController tecDesconto =  TextEditingController();
  TextEditingController tecDataCriacao =  TextEditingController(
      text: FormatingDate.getDate(
          DateTime.now(), FormatingDate.formatDDMMYYYYHHMM
      )
  );
  TextEditingController tecDataAlteracao =  TextEditingController(
      text: FormatingDate.getDate(
          DateTime.now(), FormatingDate.formatDDMMYYYYHHMM
      )
  );
  List<ItemCombo> itensCombo = [];
  CabCombo? cabComboSelected;
  double valorCombo = 0;
  @observable
  List<CabCombo> cabCombos = ObservableList.of([]);
  @observable
  List<Produto> produtos = ObservableList.of([]);
  @observable
  Map<Produto,bool> isSelected = ObservableMap.of({});
  @observable
  Map<Produto,int> qtdSelected = ObservableMap.of({});
  @observable
  bool isActive = true;
  @observable
  bool isLoading = false;

  @action
  Future<List<CabCombo>> getAll() async{
    isLoading = true;
    cabCombos = await _repository.getCombos();
    produtos = await _pRepository.getProdutosAtivos(true);
    List<ItemCombo> itensClone = await _iRepository.getItensCombos();
    itensClone.forEach((element) {
      element.produto = produtos.where((prod) => prod.id == element.produto?.id).first;
    });
    cabCombos.forEach((cab) {
      cab.itens = itensClone.where((item) => item.combo?.id == cab.id).toList();
    });
    cabCombos.sort((CabCombo a,CabCombo b) => a.descricao!.compareTo(b.descricao!));
    produtos.sort((Produto a,Produto b) => RemoveAcento().removeAcentos(a.nome!.toLowerCase()).compareTo(
        RemoveAcento().removeAcentos(b.nome!.toLowerCase()))
    );
    isLoading = false;
    return cabCombos;
  }

  @action
  setProduto(Produto produto){
    isSelected[produto] = !(isSelected[produto]??false);
    qtdSelected[produto] = 1;
    _addItemCombo(produto);
  }

  _addItemCombo(Produto produto){
    if(isSelected[produto] == true){
      ItemCombo item = ItemCombo(
          produto: produto,
          id: itensCombo.length + 1,
          preco: produto.preco,
          quantidade: qtdSelected[produto]
      );
      itensCombo.add(item);
    } else{
      for(ItemCombo item in itensCombo){
        if(item.produto == produto){
          itensCombo.remove(item);
        }
      }
    }
    _getValorCombo();
  }

  _getValorCombo(){
    valorCombo = 0;
    itensCombo.forEach((element) {
      valorCombo += element.preco!;
    });
    tecPreco.text = UtilBrasilFields.obterReal(valorCombo);
  }

  @action
  addProduto(Produto produto){
    qtdSelected[produto] = qtdSelected[produto]! + 1;
    itensCombo.where((element) => element.produto == produto).forEach((element) {
      element.quantidade = qtdSelected[produto];
      element.preco = produto.preco! * element.quantidade!;
    });
    _getValorCombo();
  }

  @action
  removeProduto(Produto produto){
    qtdSelected[produto] = qtdSelected[produto]! - 1;
    if(qtdSelected[produto]! < 1){
      qtdSelected[produto] = 0;
      setProduto(produto);
    }
    itensCombo.where((element) => element.produto == produto).forEach((element) {
      element.quantidade = qtdSelected[produto];
      element.preco = produto.preco! * element.quantidade!;
    });
    _getValorCombo();
  }

  createCombo() async{
    isLoading = true;
    CabCombo combo = CabCombo(
      dataAlteracao: DateTime.now(),
      dataCriacao: DateTime.now(),
      ativo: true,
      descricao: tecNome.text,
      descontoTotal: double.tryParse(tecDesconto.text)??0,
      valorTotal: UtilBrasilFields.converterMoedaParaDouble(tecPreco.text)
    );
    combo.id = await _repository.insertCombo(combo);
    itensCombo.forEach((element) async{
      element.combo = combo;
      await _iRepository.insertItemCombo(element);
    });
    isLoading = false;
    getAll();
  }

  updateCombo() async{
    isLoading = true;
    CabCombo combo = CabCombo(
        id: cabComboSelected?.id,
        dataAlteracao: DateTime.now(),
        dataCriacao: cabComboSelected?.dataCriacao,
        ativo: true,
        descricao: tecNome.text,
        descontoTotal: double.tryParse(tecDesconto.text)??0,
        valorTotal: UtilBrasilFields.converterMoedaParaDouble(tecPreco.text)
    );
    await _repository.updateCombo(combo);
    await _iRepository.deleteItemCombo(combo);
    itensCombo.forEach((element) async{
      element.combo = combo;
      await _iRepository.insertItemCombo(element);
    });
    isLoading = false;
    getAll();
  }

  setCombo(CabCombo combo){
    clearAll();
    cabComboSelected = combo;
    tecDataCriacao.text = FormatingDate.getDate(cabComboSelected!.dataCriacao, FormatingDate.formatDDMMYYYYHHMM);
    tecDataAlteracao.text = FormatingDate.getDate(cabComboSelected!.dataAlteracao, FormatingDate.formatDDMMYYYYHHMM);
    tecId.text = cabComboSelected!.id.toString();
    tecPreco.text = UtilBrasilFields.obterReal(cabComboSelected!.valorTotal!);
    tecDesconto.text = UtilBrasilFields.obterReal(cabComboSelected!.descontoTotal!);
    tecNome.text = cabComboSelected!.descricao!;
    itensCombo = cabComboSelected!.itens;
    // print(cabComboSelected!.itens.length);
    itensCombo.forEach((element) {
      element.produto != null ? isSelected[element.produto!] = true : null;
      element.produto != null ? qtdSelected[element.produto!] = element.quantidade??0 : null;
    });
  }

  clearAll(){
    cabComboSelected = null;
    tecDataCriacao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
    tecDataAlteracao.text = FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM);
    qtdSelected.clear();
    isSelected.clear();
    tecId.clear();
    tecPreco.clear();
    tecDesconto.clear();
    tecNome.clear();
  }
}