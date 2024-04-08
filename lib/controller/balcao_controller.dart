import 'dart:html';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/model/Estoque.dart';
import 'package:evoz_web/model/Mesa.dart';
import 'package:evoz_web/model/FormaPagamento.dart';
import 'package:evoz_web/repository/estoque_repository.dart';
import 'package:evoz_web/repository/mesa_repository.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/model/Caixa.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/model/ItemVenda.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/model/Venda.dart';
import 'package:evoz_web/pdf/vendaPdf.dart';
import 'package:evoz_web/repository/caixa_repository.dart';
import 'package:evoz_web/repository/pagamentoVenda_repository.dart';
import 'package:evoz_web/repository/produto_repository.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';
import 'package:mobx/mobx.dart';
import 'dart:ui' as ui;
import '../model/PagamentoVenda.dart';
import '../repository/itemVenda_repository.dart';
import '../repository/venda_repository.dart';

part 'balcao_controller.g.dart';

class BalcaoController = _BalcaoController with _$BalcaoController;

abstract class _BalcaoController with Store{

  final _repository = ProdutoRepository();
  final _vRepository = VendaRepository();
  final _iRepository = ItemVendaRepository();
  final _pvRepository = PagamentoVendaRepository();
  final _caixaRepository = CaixaRepository();
  final _estoqueRepository = EstoqueRepository();
  final _mesaRepository = MesaRepository();
  List<Produto> produtos = ObservableList.of([]);
  @observable
  List<Produto> produtosFiltered = ObservableList.of([]);
  @observable
  Venda? vendaSelected;
  @observable
  List<Categoria> categorias = ObservableList.of([]);
  @observable
  List<Mesa> mesas = ObservableList.of([]);
  @observable
  List<ItemVenda> itensSelected = ObservableList.of([]);
  @observable
  List<Venda> vendasComanda = ObservableList.of([]);
  @observable
  List<Venda> vendasComandaFiltered = ObservableList.of([]);
  @observable
  Caixa? currentCaixa;
  @observable
  double valorTotal = 0;
  @observable
  double valorRecebido = 0;
  @observable
  double valorRestante = 0;
  @observable
  double valorLiquido = 0;
  @observable
  double valorTroco = 0;
  @observable
  int qtdProdutos = 0;
  @observable
  bool comanda = false;
  @observable
  Map<String,bool> mapPagamento = ObservableMap.of({});
  @observable
  Map<String,double> mapPagamentoValor = ObservableMap.of({});
  @observable
  Categoria? categoriaSelected;
  @observable
  Mesa? mesaSelected;
  @observable
  bool isInserting = false;
  @observable
  bool todosSelected = true;
  @observable
  int pageSelected = 0;
  @observable
  Map<Image,String>? bandeiraSelected;
  TextEditingController tecProduto = TextEditingController();
  TextEditingController tecQuantidade = TextEditingController();
  TextEditingController tecPreco = TextEditingController();
  TextEditingController tecPrecoUnitario = TextEditingController();
  TextEditingController tecValorInicial = TextEditingController(text: "0");
  TextEditingController tecValorAtual = TextEditingController();
  TextEditingController tecDataInicial = TextEditingController(text: "0");
  TextEditingController tecCredito = TextEditingController();
  TextEditingController tecDebito = TextEditingController(text: "0");
  TextEditingController tecDinheiro = TextEditingController(text: "0");
  TextEditingController tecPix = TextEditingController(text: "0");
  TextEditingController tecTotalBruto = TextEditingController();
  TextEditingController tecTotalLiq = TextEditingController();
  TextEditingController tecDesconto = TextEditingController(text: "0");
  TextEditingController tecObsPedido = TextEditingController();
  TextEditingController tecPesquisa = TextEditingController();
  TextEditingController tecPesquisaComanda = TextEditingController();
  TextEditingController tecDataPedido = TextEditingController();
  List<Map<Image,String>> bandeiras = [];
  DateTime? _startDate;
  IFrameElement iframe = IFrameElement();

  @action
  Future getAll() async{
    _loadBandeiras();
    if(itensSelected.isEmpty){
      produtos = await _repository.getProdutosAtivos(true);
      await _getVendasPendentes();
      mesas = await _mesaRepository.getMesas();
      produtos.sort((Produto a, Produto b) =>
          RemoveAcento().removeAcentos(a.nome!.toLowerCase()).compareTo(RemoveAcento().removeAcentos(b.nome!.toLowerCase()))
      );
      produtosFiltered = produtos;
      await _getCaixa();
      categorias = _repository.categorias;
      qtdProdutos = produtos.length;
    }
  }


  Future<IFrameElement> createLayoutIfood() async{
    String content = '''
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script async src="https://widgets.ifood.com.br/widget.js"></script>
          <script>
            window.addEventListener('load', () => {
              iFoodWidget.init({
                widgetId: '12ac48cc-2a2f-4346-a6f1-a3b6af344939',
                merchantIds: [
                  '${Global().iFood?.merchantId}'
                ],
              });
            });
          </script>
        </head>
      </html>
    ''';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'ifood-html-view',
            (int viewId){
          iframe = IFrameElement()
          // ..style.border = 'none'
            ..srcdoc = content;
          return iframe;
        });
    return iframe;
  }

  Future _getVendasPendentes() async{
    vendasComanda = await _vRepository.getVendasPendentes();
    List<int> ids = [];
    vendasComanda.forEach((element) {
      ids.add(element.id!);
    });
    List<ItemVenda> itensClone = await _iRepository.getItens(ids);
    vendasComanda.forEach((venda) {
      itensClone.where((element) => element.venda == venda.id).forEach((element) {
        produtos.where((produto) =>
        produto.nome!.toLowerCase().trim() == element.nomeProduto!.toLowerCase().trim()).forEach((produto) {
          element.produto = produto;
          venda.itens.add(element);
        });
      });
    });
    vendasComandaFiltered = vendasComanda;
  }

  @action
  filterComandas(){
    vendasComandaFiltered = vendasComanda.where((element) =>
        element.id.toString().contains(tecPesquisaComanda.text)
            || element.valorLiquido.toString().contains(tecPesquisaComanda.text)
    ).toList();
  }

  @action
  alterProdutos(Produto produto, BuildContext context,{String? operation}) {
    ItemVenda? itemClone;
    bool exist = false;
    itensSelected.where((element) => element.produto == produto).forEach((element) {
      exist = true;
      itemClone = element;
    });
    if(operation == null){
      if(exist){
        if(produto.utilizaEstoque == false || (produto.estoque??0) > itemClone!.quantidade!){
          itensSelected.remove(itemClone!);
          itemClone!.quantidade = itemClone!.quantidade! + 1;
          itemClone!.preco = itemClone!.precoUnitario! * itemClone!.quantidade!;
          itensSelected.add(itemClone!);
        } else{
          CustomSnackbar(
              message: "Estoque insuficiente",
              backgroundColor: Colors.red,
              textColor: Colors.white
          ).show(context);
        }
      } else {
        if(((produto.estoque??0) > 0) || produto.utilizaEstoque == false) {
          itemClone = ItemVenda(
              id: itensSelected.length + 1,
              quantidade: 1,
              preco: produto.preco,
              produto: produto,
              nomeProduto: produto.nome,
              precoUnitario: produto.preco
          );
          itensSelected.add(itemClone!);
        } else {
          CustomSnackbar(
              message: "Estoque insuficiente",
              backgroundColor: Colors.red,
              textColor: Colors.white
          ).show(context);
        }
      }
    } else{
      itensSelected.remove(itemClone!);
      itemClone!.quantidade = itemClone!.quantidade! - 1;
      itemClone!.preco = itemClone!.precoUnitario! * itemClone!.quantidade!;
      itemClone!.quantidade! > 0 ? itensSelected.add(itemClone!) : null;
    }
    _getValorTotal();
    itensSelected.sort((a, b) => a.id!.compareTo(b.id!));
  }

  @action
  Future setDateVenda(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now() ,
        firstDate: DateTime(2023),
        lastDate: DateTime.now(),
        helpText: "De"
    );
    if (picked != null) {
      _startDate = picked;
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now())
      );
      if(pickedTime != null){
        _startDate = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        tecDataPedido.text = FormatingDate.getDate(_startDate, FormatingDate.formatDDMMYYYYHHMM);
      }
    }
  }


  _getValorTotal(){
    valorTotal = 0;
    itensSelected.forEach((element) {
      valorTotal = valorTotal + element.preco!;
    });
    valorLiquido = valorTotal;
  }

  setItem(ItemVenda item){
    tecProduto.text = item.produto!.nome!;
    tecQuantidade.text = item.quantidade.toString();
    tecPreco.text = item.preco!.toStringAsFixed(2);
    tecPrecoUnitario.text = item.precoUnitario!.toStringAsFixed(2);
  }

  onChangeQtd(ItemVenda item){
    tecPreco.text = ((int.tryParse(tecQuantidade.text)??0) * item.produto!.preco!).toStringAsFixed(2);
    itensSelected.sort((a, b) => a.id!.compareTo(b.id!));
  }

  @action
  saveItem(ItemVenda item){
    item.quantidade = int.tryParse(tecQuantidade.text)??0;
    item.preco = double.tryParse(tecPreco.text)??0;
    item.precoUnitario = double.tryParse(tecPrecoUnitario.text)??0;
    itensSelected.remove(item);
    item.quantidade != 0 ? itensSelected.add(item) : null;
    itensSelected.sort((a, b) => a.id!.compareTo(b.id!));
    _getValorTotal();
  }

  @action
  setComanda(){
    comanda = !comanda;
  }

  @action
  alterCaixa() async{
    if(currentCaixa?.ativo == true){
      Caixa caixa = Caixa(
          id: currentCaixa!.id,
          ativo: false,
          dataInicio: currentCaixa!.dataInicio,
          usuario: currentCaixa!.usuario,
          valorInicial: currentCaixa!.valorInicial,
          valorAtual: currentCaixa!.valorAtual,
          dataAlteracao: DateTime.now(),
          dataFim: DateTime.now()
      );
      currentCaixa = caixa;
      // print(currentCaixa?.toJson());
      await _caixaRepository.updateCaixa(currentCaixa!);
    } else {
      Caixa caixa = Caixa(
        ativo: true,
        dataInicio: DateTime.now(),
        dataAlteracao: DateTime.now(),
        usuario: Global().usuario,
        valorInicial: UtilBrasilFields.converterMoedaParaDouble(tecValorInicial.text),
        valorAtual: UtilBrasilFields.converterMoedaParaDouble(tecValorInicial.text),
      );
      currentCaixa = caixa;
      await _caixaRepository.insertCaixa(currentCaixa!);
      // currentCaixa = null;
    }
    await _getCaixa();
  }

  @action
  setCaixa(){
    if(currentCaixa != null){
      if(currentCaixa!.ativo!){
        tecValorInicial.text = UtilBrasilFields.obterReal(currentCaixa!.valorInicial!);
        tecValorAtual.text = UtilBrasilFields.obterReal(currentCaixa!.valorAtual!);
        tecDataInicial.text = FormatingDate.getDate(currentCaixa!.dataInicio!,FormatingDate.formatDDMMYYYYHHMM);
      } else {
        tecValorInicial.text = UtilBrasilFields.obterReal(0);
        tecDataInicial.text = "Agora";
      }
    } else {
      tecValorInicial.text = UtilBrasilFields.obterReal(0);
      tecDataInicial.text = "Agora";
    }
  }

  _getCaixa() async{
    currentCaixa = await _caixaRepository.getCaixa();
  }

  @action
  setPagamento(FormaPagamento pagamento, TextEditingController tec){
    mapPagamento[pagamento.descricao!] = !(mapPagamento[pagamento.descricao]??false);
    tec.text = mapPagamento[pagamento.descricao] == true ? UtilBrasilFields.obterReal(valorRestante) : "0";
    mapPagamentoValor[pagamento.descricao!] = UtilBrasilFields.converterMoedaParaDouble(tec.text);
  }

  @action
  getValorRestante(){
    double dinheiro = tecDinheiro.text.isEmpty ? 0 : UtilBrasilFields.converterMoedaParaDouble(tecDinheiro.text);
    mapPagamentoValor["Dinheiro"] = dinheiro;
    double debito = tecDebito.text.isEmpty ? 0 : UtilBrasilFields.converterMoedaParaDouble(tecDebito.text);
    mapPagamentoValor["Cartão de Débito"] = debito;
    double credito = tecCredito.text.isEmpty ? 0 :UtilBrasilFields.converterMoedaParaDouble(tecCredito.text);
    mapPagamentoValor["Cartão de Crédito"] = credito;
    double pix = tecPix.text.isEmpty ? 0 : UtilBrasilFields.converterMoedaParaDouble(tecPix.text);
    mapPagamentoValor["Pix"] = pix;
    valorRecebido = dinheiro + credito + debito + pix;
    _getTroco();
    if((mapPagamentoValor["Dinheiro"]??0) < valorLiquido){
      valorRestante = valorLiquido - (dinheiro + credito + debito + pix);
    } else {
      if(valorLiquido > UtilBrasilFields.converterMoedaParaDouble(tecDinheiro.text.isEmpty?"0":tecDinheiro.text)){
        valorRestante = valorLiquido - (dinheiro + credito + debito + pix);
      } else {
        valorRestante = 0;
      }
    }
    tecTotalBruto.text = UtilBrasilFields.obterReal(valorTotal);
    if(tecDesconto.text.isNotEmpty){
      tecTotalLiq.text = UtilBrasilFields.obterReal(
          valorTotal - UtilBrasilFields.converterMoedaParaDouble(tecDesconto.text)
      );
    } else {
      tecTotalLiq.text = tecTotalBruto.text;
    }
  }

  @action
  setCategoria(Categoria? categoria){
    if(categoriaSelected == categoria){
      produtosFiltered = produtos;
      categoriaSelected = null;
      setTodos(true);
    } else {
      categoriaSelected = categoria;
      setTodos(false);
    }
    _filterProdutosByCategoria();
  }

  @action
  setTodos(bool value){
    todosSelected = value;
    if(todosSelected == true){
      categoriaSelected = null;
    }
    _filterProdutosByCategoria();
  }

  _filterProdutosByCategoria(){
    if(!todosSelected){
      produtosFiltered = produtos.where((element) => element.categoria == categoriaSelected).toList();
    } else {
      produtosFiltered = produtos;
    }
  }

  @action
  filterProdutosByDescricao(){
    produtosFiltered = produtos.where(
            (element) => RemoveAcento().removeAcentos(element.nome!.toLowerCase()).
            contains(RemoveAcento().removeAcentos(tecPesquisa.text.toLowerCase()))).toList();
  }

  @action
  setDesconto(){
    tecDesconto.text.isEmpty ? tecDesconto.text = UtilBrasilFields.obterReal(0.00) : null;
    double desconto = UtilBrasilFields.converterMoedaParaDouble(tecDesconto.text);
    tecTotalLiq.text = UtilBrasilFields.obterReal(valorTotal - desconto);
    valorLiquido = valorTotal - desconto;
    getValorRestante();
  }

  _getTroco(){
    valorTroco = 0;
    double debito = tecDebito.text.isEmpty ? 0 : UtilBrasilFields.converterMoedaParaDouble(tecDebito.text);
    mapPagamentoValor["Cartão de Débito"] = debito;
    double credito = tecCredito.text.isEmpty ? 0 :UtilBrasilFields.converterMoedaParaDouble(tecCredito.text);
    mapPagamentoValor["Cartão de Crédito"] = credito;
    double pix = tecPix.text.isEmpty ? 0 : UtilBrasilFields.converterMoedaParaDouble(tecPix.text);
    mapPagamentoValor["Pix"] = pix;

    if((mapPagamentoValor['Dinheiro']??0) > 0 && valorRecebido > valorLiquido){
      valorTroco = (mapPagamentoValor['Dinheiro']??0) - (valorLiquido - (debito + credito + pix));
    }
  }

  @action
  Future createVenda() async{
    isInserting = true;
    int vendaId = 0;
    Venda venda = Venda(
        id: vendaSelected != null ? vendaSelected!.id! : null,
        usuario: Global().usuario,
        dataAlteracao: DateTime.now(),
        comanda: comanda,
        dataPedido:_startDate??(vendaSelected != null ? vendaSelected!.dataPedido : DateTime.now()),
        mesa: mesaSelected?.id,
        desconto: UtilBrasilFields.converterMoedaParaDouble(tecDesconto.text.isEmpty ? "0" : tecDesconto.text),
        valorBruto: valorTotal,
        valorLiquido: valorLiquido,
        valorTroco: valorTroco
    );
    venda.itens = itensSelected;
    if(vendaSelected != null){
      await _vRepository.updateVenda(venda);
    } else{
      vendaId = await _vRepository.insertVenda(venda);
    }
    await _insertItens(vendaSelected != null ? vendaSelected!.id! : vendaId, isComanda: venda.comanda);
    await _insertPagamentos(vendaSelected != null ? vendaSelected!.id! : vendaId, venda);
    await _saveMesas(venda.valorLiquido!);
    _clearAll();
    getAll();
    isInserting = false;
  }

  _insertItens(int vendaId,{bool? isComanda}) async{
    await _iRepository.deleteItens(vendaId);
    itensSelected.forEach((element) async{
      element.venda = vendaId;
      Estoque estoque = Estoque(
          dataAlteracao: DateTime.now(),
          produto: element.produto!.id,
          nomeProduto: element.nomeProduto,
          operacao: "${element.quantidade} unidade(s) de ${element.nomeProduto} vendidas ",
          usuario: Global().usuario!.nome,
          estoqueAtual: vendaSelected?.id == vendaId
              ? element.produto!.estoque!
              : element.produto!.estoque! - element.quantidade!
      );
      await _iRepository.insertItens(element);
      if(element.produto!.utilizaEstoque == true && isComanda != true){
        await _estoqueRepository.insertEstoque(estoque);
      }
    });
  }

  _insertPagamentos(int vendaId, Venda venda) async{
    int id = 1;
    mapPagamentoValor.forEach((key, value) {
      if(value > 0){
        PagamentoVenda pagamentoVenda = PagamentoVenda(
            id: id,
            pagamento: key,
            valor: value,
            venda: vendaId,
            valorTroco: valorTroco
        );
        venda.pagamentos.add(pagamentoVenda);
        id++;
      }
    });
    venda.pagamentos.forEach((element) async{
      if(element.pagamento == "Dinheiro"){
        currentCaixa!.dataAlteracao = DateTime.now();
        currentCaixa!.valorAtual = currentCaixa!.valorAtual! + (element.valor! - valorTroco);
        await _caixaRepository.updateCaixa(currentCaixa!);
      }
      await _pvRepository.insertPagamentos(element);
    });
    // _clearAll();
  }

  _clearAll() {
    itensSelected.clear();
    valorTotal = 0;
    valorLiquido = 0;
    valorRestante = 0;
    valorTroco = 0;
    valorRecebido = 0;
    comanda = false;
    mesaSelected = null;
    tecQuantidade.clear();
    tecValorInicial.clear();
    tecDinheiro.clear();
    tecDebito.clear();
    tecDesconto.clear();
    tecCredito.clear();
    tecPix.clear();
    tecObsPedido.clear();
    tecPrecoUnitario.clear();
    tecProduto.clear();
    mapPagamento.clear();
    setVenda(null);
  }

  @action
  setVenda(dynamic venda){
    vendaSelected = venda;
    mesas.where((element) => element.id == vendaSelected?.mesa).forEach((element) {
      mesaSelected = element;
    });
    if(vendaSelected != null){
      itensSelected = venda.itens;
    } else{
      itensSelected = [];
    }
    _getValorTotal();
  }

  int getQtdProduto(Produto produto){
    int qtd = 0;
    itensSelected.where((element) => element.produto == produto).forEach((element) {
      qtd = element.quantidade!;
    });
    return qtd;
  }

  @action
  setMesa(Mesa mesa){
    mesaSelected = mesa;
  }

  _saveMesas(double valorVenda) async{
    double valor = 0;
    int count = 0;
    vendasComanda.where((element) => element.mesa == mesaSelected?.id && element.id != vendaSelected?.id).forEach((element) {
      valor = valor + element.valorLiquido!;
      count ++;
    });
    if(mesaSelected != null){
      if(count == 0 && comanda == false){
        mesaSelected?.ultimaVenda = DateTime(1966,04,24);
        mesaSelected?.statusOcupacao = 'Disponível';
        mesaSelected?.valorTotal = 0;
      } else{
        mesaSelected?.valorTotal = valorVenda + valor;
        mesaSelected?.statusOcupacao = 'Em Uso';
        mesaSelected?.ultimaVenda = DateTime.now();
      }
      await _mesaRepository.updateMesa(mesaSelected!);
    }
  }

  @action
  setPage(int index){
    pageSelected = index;
  }

  _loadBandeiras(){
    bandeiras = [];
    bandeiras.add({Image.asset("assets/alelo.png",width: 25,):"Alelo"});
    bandeiras.add({Image.asset("assets/amex.png",width: 25,):"Amex"});
    bandeiras.add({Image.asset("assets/discover.png",width: 25,):"Discover"});
    bandeiras.add({Image.asset("assets/elo 2.png",width: 25,):"Elo"});
    bandeiras.add({Image.asset("assets/mastercard.png",width: 25,):"Mastercard"});
    bandeiras.add({Image.asset("assets/visa.png",width: 25,):"Visa"});
  }

  @action
  setBandeira(FormaPagamento pagamento,String bandeira){
    bool exists = false;
    pagamento.bandeiras.where((element) => element == bandeira).forEach((element) {
      exists = true;
      pagamento.bandeiras.remove(element);
    });
    exists == false ? pagamento.bandeiras.add(bandeira) : null;
    // print(pagamento.bandeiras.length);
  }
}