import 'package:evoz_web/components/circle_number.dart';
import 'package:evoz_web/components/container_mesa.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/mesa_controller.dart';
import 'package:evoz_web/events/dialog_mesa.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MesaView extends StatelessWidget {
  MesaView({Key? key}) : super(key: key);
  final _controller = MesaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
          onPressed: (){
            DialogMesa().show(context, _controller);
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return CustomTitle(
                  title: "Mesas",
                  widget: CircleNumber(_controller.mesas.length)
              );
            }
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.greenAccent.shade700,
                  ),
                  Text(" Disponível")
                ],
              ),
              SizedBox(width: 8,),
              // Row(
              //   children: [
              //     Container(
              //       height: 10,
              //       width: 10,
              //       color: Colors.redAccent,
              //     ),
              //     Text(" Ocupado")
              //   ],
              // ),
              SizedBox(width: 8,),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.yellow.shade700,
                  ),
                  Text(" Em Uso")
                ],
              ),
            ],
          ),
          SizedBox(height: 8,),
          FutureBuilder(
            future: _controller.getMesas(),
            builder: (context, snapshot) {
              return Expanded(
                  child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                    builder: (context) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _controller.mesas.length,
                        itemBuilder: (BuildContext context, index) {
                          return ContainerMesa(
                              mesa: _controller.mesas[index],
                              controller: _controller
                          );
                        },
                      );
                    }
                  ),
              );
            },)
        ],
      ),
    );
  }
}
