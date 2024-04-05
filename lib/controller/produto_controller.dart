import 'dart:typed_data';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/model/Estoque.dart';
import 'package:evoz_web/model/Marca.dart';
import 'package:evoz_web/model/ProdutoTamanho.dart';
import 'package:evoz_web/repository/estoque_repository.dart';
import 'package:evoz_web/repository/marca_repository.dart';
import 'package:evoz_web/repository/produtoTamanho_repository.dart';
import 'package:evoz_web/service/remove_acento.dart';
import 'package:evoz_web/service/upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:evoz_web/model/categoria/Categoria.dart';
import 'package:evoz_web/model/Produto.dart';
import 'package:evoz_web/repository/produto_repository.dart';
import 'package:evoz_web/util/global.dart';
import 'package:mobx/mobx.dart';

part 'produto_controller.g.dart';

class ProdutoController = _ProdutoController with _$ProdutoController;

abstract class _ProdutoController with Store{

  @observable
  List<Produto> produtos = ObservableList.of([]);
  @observable
  List<Produto> produtosFiltered = ObservableList.of([]);
  @observable
  List<Categoria> categorias = ObservableList.of([]);
  @observable
  List<Marca> marcas = ObservableList.of([]);
  @observable
  List<TextEditingController> tecsTamanho = ObservableList.of([]);
  final _pRepository = ProdutoRepository();
  final _eRepository = EstoqueRepository();
  final _tRepository = ProdutoTamanhoRepository();
  TextEditingController tecId = TextEditingController();
  TextEditingController tecNome = TextEditingController();
  TextEditingController tecPreco = TextEditingController();
  TextEditingController tecEstoque = TextEditingController();
  TextEditingController tecDtCriacao = TextEditingController();
  TextEditingController tecDtAlteracao = TextEditingController();
  TextEditingController tecPesquisa = TextEditingController();
  @observable
  bool isLoading = false;
  @observable
  int page = 0;
  @observable
  int qtdProdutos = 0;
  @observable
  bool isActived = true;
  @observable
  bool useCategory = false;
  @observable
  bool useMarca = false;
  @observable
  Categoria? categoriaSelected;
  @observable
  Marca? marcaSelected;
  @observable
  int buttonSelected = 0;
  @observable
  bool utilizaEstoque = true;
  @observable
  Uint8List? bytesImage;
  final formKey = GlobalKey<FormState>();

  Future<List<Produto>> getAll({bool? sincCategories}) async{
    produtos = await _pRepository.getProdutos();
    sincCategories == false ? null : getCategorias();
    sincCategories == false ? null : getMarcas();
    // List<ProdutoTamanho> tamanhos = await _tRepository.getProdutoTamanho();
    // produtos.forEach((produto) {
    //   tamanhos.where((element) => element.produto == produto.id).forEach((element) {
    //     produto.tamanhos.add(element);
    //   });
    // });
    produtosFiltered = produtos;
    produtos.sort((Produto a, Produto b) =>
        RemoveAcento().removeAcentos(a.nome!.toLowerCase()).compareTo(RemoveAcento().removeAcentos(b.nome!.toLowerCase()))
    );
    qtdProdutos = produtos.length;
    categoriaSelected = null;
    setButtonCategory(0);
    return produtos;
  }

  Future<List<Produto>> getProdutosAtivos(bool ativo) async{
    produtos = await _pRepository.getProdutosAtivos(ativo);
    qtdProdutos = produtos.length;
    return produtos;
  }

  getCategorias(){
    categorias = _pRepository.categorias;
  }

  getMarcas(){
    marcas = _pRepository.marcas;
  }

  @action
  changeActived(){
    isActived = !isActived;
  }

  @action
  changeCategory(Categoria categoria){
    categoriaSelected = categoria;
  }

  changeUseCategory(){
    useCategory = !useCategory;
  }

  @action
  changeMarca(Marca marca){
    marcaSelected = marca;
  }

  changeUseMarca(){
    useMarca = !useMarca;
  }

  @action
  Future insertProduto() async{
    isLoading = true;
    Produto produto = Produto(
        nome: tecNome.text,
        preco: UtilBrasilFields.converterMoedaParaDouble(tecPreco.text),
        ativo: isActived,
        categoria: useCategory ? categoriaSelected : null,
        utilizaEstoque: utilizaEstoque,
        estoque: utilizaEstoque ? int.parse(tecEstoque.text) : 0,
        dataCriacao: DateTime.now(),
        dataAlteracao: DateTime.now(),
        urlImage: bytesImage != null ? _defineUrl() : null,
        marca: useMarca ? marcaSelected : null,
    );
    produto.id = await _pRepository.insertProduto(produto);
    bytesImage != null ? await uploadImage(produto) : null;
    Estoque estoque = Estoque(
        dataAlteracao: DateTime.now(),
        produto: produto.id,
        nomeProduto: produto.nome,
        operacao: "${produto.nome} criado com o estoque inicial de ${produto.estoque} unidade(s)",
        usuario: Global().usuario!.nome
    );
    produto.utilizaEstoque??false ? await _eRepository.insertEstoque(estoque) : null;
    await _createProdutoTamanho(produto);
    await getAll(sincCategories: false);
    isLoading = false;
  }

  Future deleteProduto(Produto produto) async{
    isLoading = true;
    await _pRepository.deleteProduto(produto);
    _tRepository.deleteProdutoTamanho(produto);
    await getAll(sincCategories: false);
    isLoading = false;
    // await getProdutos();
  }

  Future updateProduto(Produto produto) async{
    isLoading = true;
    Estoque estoque = Estoque(
        dataAlteracao: DateTime.now(),
        produto: produto.id,
        nomeProduto: produto.nome,
        operacao: "${produto.estoque! < (int.parse(tecEstoque.text))
            ? "Adição de " : "Remoção de " }${
            (int.parse(tecEstoque.text)) - produto.estoque!} unidade(s) para ${produto.nome}",
        usuario: Global().usuario!.nome,
      estoqueAtual: int.parse(tecEstoque.text)
    );
    produto = Produto(
        id: produto.id,
        nome: tecNome.text,
        preco: UtilBrasilFields.converterMoedaParaDouble(tecPreco.text),
        ativo: isActived,
        utilizaEstoque: utilizaEstoque,
        estoque: utilizaEstoque ? int.parse(tecEstoque.text) : 0,
        categoria: useCategory ? categoriaSelected : null,
        dataCriacao: produto.dataCriacao,
        dataAlteracao: DateTime.now(),
        urlImage: bytesImage != null ? _defineUrl() : produto.urlImage,
        marca: useMarca ? marcaSelected : null,
    );
    await _pRepository.updateProduto(produto);
    bytesImage != null ? await uploadImage(produto) : null;
    await _createProdutoTamanho(produto);
    await getAll(sincCategories: false);
    if((produto.utilizaEstoque??false) && produto.estoque != int.parse(tecEstoque.text)){
      await _eRepository.insertEstoque(estoque);
    }
    isLoading = false;
    // await getProdutos();
  }

  @action
  setPage(int index){
    page = index;
  }

  @action
  setButtonCategory(int index){
    buttonSelected = index;
    _filterCategoryByButton(buttonSelected);
  }

  _filterCategoryByButton(int index){
    produtosFiltered = index == 0 ? produtos : produtos.where((element) => element.categoria?.id == index).toList();
  }

  @action
  filterProdutosByDescricao(){
    produtosFiltered = produtos.where(
            (element) => RemoveAcento().removeAcentos(element.nome!.toLowerCase()).
        contains(RemoveAcento().removeAcentos(tecPesquisa.text.toLowerCase()))).toList();
  }

  @action
  setUtilizaEstoque(){
    utilizaEstoque = !utilizaEstoque;
  }

  @action
  setImage(Uint8List? bytes){
    bytesImage = bytes;
  }

  uploadImage(Produto produto) async{
    await UploadImage().loadImage(produto.nome!, bytesImage!);
  }

  @action
  addTecTamanho(){
    tecsTamanho.add(TextEditingController());
  }

  @action
  removeTecTamanho(int index){
    tecsTamanho.removeAt(index);
  }

  _createProdutoTamanho(Produto produto) async{
    for(int i = 0; i < tecsTamanho.length; i++){
      ProdutoTamanho tamanho = ProdutoTamanho(
        id: i+1,
        produto: produto.id,
        quantidade: 100,
        tamanho: tecsTamanho[i].text
      );
      produto.tamanhos.add(tamanho);
    }
    await _tRepository.deleteProdutoTamanho(produto);
    produto.tamanhos.forEach((element) async{
      await _tRepository.insertProdutoTamanho(element);
    });
    tecsTamanho.clear();
  }

  String _defineUrl(){
    String url = "https://evozw.com.br/images/${Global().idEmpresa}/${RemoveAcento()
        .removeAcentos(tecNome.text).replaceAll(' ', '_').toLowerCase()}.png";
    return url;
  }
}