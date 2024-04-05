import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoz_web/components/circle_number.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/marca_controller.dart';
import 'package:evoz_web/events/dialog_confirm.dart';
import 'package:evoz_web/events/dialog_marca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MarcaPageView extends StatelessWidget {
  final _controller = MarcaController();
  MarcaPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
          onPressed: (){
            DialogMarca().show(context, _controller);
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return CustomTitle(
                  title: "Marcas",
                  widget: CircleNumber(_controller.qtdMarcas)
              );
            }
          ),
          Divider(),
          FutureBuilder(future: _controller.getMarcas(),builder: (context, snapshot) {
            return Expanded(child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) :
            Observer(
              builder: (context) {
                return ListView.builder(
                    itemCount: _controller.marcas.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          DialogMarca().show(context, _controller, marca: _controller.marcas[index]);
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                InkWell(
                                  child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CachedNetworkImage(
                                        imageUrl:_controller.marcas[index].urlLogo??'',
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(child: Icon(Icons.image_not_supported_outlined)),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            child: CachedNetworkImage(
                                              imageUrl: _controller.marcas[index].urlLogo??'',
                                              errorWidget: (context, url, error) =>
                                                  CircleAvatar(child: Icon(Icons.image_not_supported_outlined)),
                                            )
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 8),
                                Expanded(child: Text("${_controller.marcas[index].nome}")),
                                IconButton(
                                    onPressed: (){
                                      DialogConfirm().show(
                                          context,
                                          "Excluir a marca",
                                          _controller.isLoading,
                                              () async{
                                            await _controller.deleteMarca(_controller.marcas[index]);
                                          });
                                    },
                                    icon: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
            ));
          })
        ],
      ),
    );
  }
}
