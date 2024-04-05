import 'package:evoz_web/model/categoria/pizza/CategoriaPizzaTamanho.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/repository/categoria_repository.dart';
import 'package:mobx/mobx.dart';

import '../model/categoria/Categoria.dart';

part 'categoria_controller.g.dart';

class CategoriaController = _CategoriaController with _$CategoriaController;

abstract class _CategoriaController with Store {
  final _cRepository = CategoriaRepository();
  TextEditingController cTecId = TextEditingController();
  TextEditingController cTecNome = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @observable
  List<Categoria> categorias = ObservableList.of([]);
  @observable
  bool isLoading = false;
  @observable
  bool isSincronized = false;
  @observable
  bool isActived = true;
  @observable
  int qtdCategorias = 0;
  @observable
  int? categoriaSelected = -1;
  @observable
  List<CategoriaPizzaTamanho> sizePizza = [];
  @observable
  List<TextEditingController> tecPizzaTamNome = [TextEditingController(),TextEditingController(),TextEditingController()];
  List<TextEditingController> tecPizzaTamPdco = [TextEditingController(),TextEditingController(),TextEditingController()];
  List<TextEditingController> tecPizzaTamSabo = [TextEditingController(),TextEditingController(),TextEditingController()];
  @observable
  int pagePizza = 0;

  @action
  Future<List<Categoria>> getCategorias() async{
    categorias = await _cRepository.getCategorias();
    qtdCategorias = categorias.length;
    isSincronized = true;
    return categorias;
  }

  @action
  Future insertCategorias() async{
    Categoria categoria = Categoria(
      nome: cTecNome.text,
      ativo: isActived,
    );
    isLoading = true;
    await _cRepository.postCategoria(categoria);
    await getCategorias();
    isLoading = false;
  }

  @action
  Future deleteCategorias(Categoria categoria) async{
    isLoading = true;
    await _cRepository.deleteCategoria(categoria);
    await getCategorias();
    isLoading = false;
  }

  @action
  Future updateCategorias(Categoria categoria) async{
    isLoading = true;
    categoria = Categoria(
      id: categoria.id,
      nome: cTecNome.text,
      ativo: isActived,
    );
    await _cRepository.updateCategoria(categoria);
    await getCategorias();
    isLoading = false;
  }

  @action
  changeActived(){
    isActived = !isActived;
  }

  @action
  setCategoria(int index){
    categoriaSelected = index;
    _createDefaultPizza();
  }

  @action
  addTamanhoPizza(){
    tecPizzaTamNome.add(TextEditingController());
  }

  @action
  removeTamanhoPizza(){
    tecPizzaTamNome.remove(TextEditingController());
  }

  _createDefaultPizza(){
    sizePizza = [];
    CategoriaPizzaTamanho smallPizza = CategoriaPizzaTamanho(id: 0,nome: "Pequena",qtdPedacos: 1,qtdSabores: 1);
    CategoriaPizzaTamanho mediumPizza = CategoriaPizzaTamanho(id: 1,nome: "Média",qtdPedacos: 6,qtdSabores: 2);
    CategoriaPizzaTamanho bigPizza = CategoriaPizzaTamanho(id: 2,nome: "Grande",qtdPedacos: 8,qtdSabores: 3);
    tecPizzaTamNome[0].text = smallPizza.nome!;
    tecPizzaTamNome[1].text = mediumPizza.nome!;
    tecPizzaTamNome[2].text = bigPizza.nome!;
    tecPizzaTamPdco[0].text = smallPizza.qtdPedacos.toString();
    tecPizzaTamPdco[1].text = mediumPizza.qtdPedacos.toString();
    tecPizzaTamPdco[2].text = bigPizza.qtdPedacos.toString();
    tecPizzaTamSabo[0].text = smallPizza.qtdSabores.toString();
    tecPizzaTamSabo[1].text = mediumPizza.qtdSabores.toString();
    tecPizzaTamSabo[2].text = bigPizza.qtdSabores.toString();
    sizePizza.add(smallPizza);
    sizePizza.add(mediumPizza);
    sizePizza.add(bigPizza);
    // print(sizePizza.length);
  }

  @action
  setPagePizza(int page){
    pagePizza = page;
  }
}
