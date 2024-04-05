import 'package:evoz_web/components/circle_number.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/util/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/categoria_controller.dart';
import 'package:evoz_web/events/dialog_categoria.dart';
import 'package:evoz_web/events/dialog_confirm.dart';

class CategoriaPageView extends StatelessWidget {
  final controller = CategoriaController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CategoriaPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:  _scaffoldKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
            onPressed: (){
              DialogCategoria().show(context,controller);
            },
            child: Icon(Icons.add)
        ),
      ),
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return CustomTitle(
                  title: "Categorias",
                  widget: CircleNumber(controller.categorias.length)
              );
            }
          ),
          Divider(),
          FutureBuilder(
            future: controller.getCategorias(),
            builder: (context, snapshot) {
              return Expanded(
                  child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                    builder: (context) {
                      return ListView.builder(
                          itemCount: controller.categorias.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                               DialogCategoria().show(context,controller,categoria: controller.categorias[index]);
                              },
                              child: Card(
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                                Global().empresa!.segmento!.icone!
                                            )
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(child: Text("${controller.categorias[index].nome}")),
                                          IconButton(
                                              onPressed: (){
                                                DialogConfirm().show(
                                                    context,
                                                    "Excluir a categoria",
                                                    controller.isLoading,
                                                        () async{
                                                      await controller.deleteCategorias(controller.categorias[index]);
                                                    });
                                              },
                                              icon: Icon(Icons.delete_forever_outlined,color: Colors.red,)
                                          )
                                        ],
                                      )
                                  )
                              ),
                            );
                          });
                    }
                  )
              );
            },)
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width > 650
            ? MediaQuery.of(context).size.width * 0.45 : MediaQuery.of(context).size.width * 0.85,
        child: Observer(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Nova Categoria",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Divider(),
                  ),
                  controller.categoriaSelected == -1
                      ? _drawerDefault()
                      : controller.categoriaSelected == 0
                      ? _drawerItensPrincipais()
                      : _drawerPizzas(context,[_drawerPizzaDetalhes(),_drawerPizzaTamanhos()])
                ],
              ),
            );
          }
        ),
      ),
    );
  }
  _listTile(String text, String subTitle, Icon icon,int index, {BuildContext? context}){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100)
      ),
      child: ListTile(
        leading: icon,
        title: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: Row(
          children: [
            Expanded(child: Text(subTitle)),
            if(index == controller.categoriaSelected)
              TextButton(
                  onPressed: (){
                    controller.setCategoria(-1);
                  },
                  child: Text("Alterar")
              )
          ],
        ),
        onTap: (){
          controller.setCategoria(index);
        },
      ),
    );
  }
  Widget _drawerDefault(){
    return Column(
      children: [
        _listTile(
            "Itens Principais",
            "Comidas, lanches, sobremesas, etc.",
            Icon(Icons.flatware_outlined),
            0
        ),
        _listTile("Pizza", "Defina o tamanho,tipo de massas, bordas e sabores", Icon(Icons.local_pizza_outlined),1),
      ],
    );
  }

  Widget _drawerItensPrincipais(){
    return Column(
      children: [
        _listTile("Itens Principais", "Comidas, lanches, sobremesas, etc.",Icon(Icons.flatware_outlined),0),
        CustomTextField(tec: controller.cTecNome, label: "Nome da categoria")
      ],
    );
  }

  Widget _drawerPizzas(BuildContext context, List<Widget> pages){
    return Column(
      children: [
        _listTile("Pizza", "Defina o tamanho,tipo de massas, bordas e sabores", Icon(Icons.local_pizza_outlined),1),
        Row(
          children: [
            _buttonPage("Detalhes", 0,context),
            _buttonPage("Tamanhos", 1,context),
            _buttonPage("Massas", 2,context),
            _buttonPage("Bordas", 3,context)
          ],
        ),
        pages[controller.pagePizza]
        // CustomTextField(tec: controller.cTecNome, label: "Nome da categoria")
      ],
    );
  }

  Widget _drawerPizzaDetalhes(){
    return CustomTextField(tec: controller.cTecNome, label: "Nome da categoria");
  }

  Widget _drawerPizzaTamanhos(){
    print(controller.sizePizza.length);
    return Column(
      children: [
        for(int i = 0; i < controller.sizePizza.length; i++)
          Row(
            children: [
              Expanded(child: CustomTextField(tec: controller.tecPizzaTamNome[i], label: "Nome")),
              SizedBox(width: 8,),
              SizedBox(
                width: 100,
                child: CustomTextField(tec: controller.tecPizzaTamPdco[i], label: "Qtd Pedaços"),
              ),
              SizedBox(width: 8,),
              SizedBox(
                width: 100,
                child: CustomTextField(tec: controller.tecPizzaTamSabo[i], label: "Qtd Sabores"),
              ),
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.delete_outline)
              )
            ],
          ),
        TextButton(
            onPressed: (){},
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 8,),
                Text("Novo tamanho"),
              ],
            )
        )
      ],
    );
  }

  _buttonPage(String page, int index, BuildContext context){
    return TextButton(
        onPressed: (){
          controller.setPagePizza(index);
        },
        child: Text(page,
            style: TextStyle(color: controller.pagePizza == index
                ? Theme.of(context).colorScheme.inverseSurface
                : null
            )
        )
    );
  }
}
