import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/combo_controller.dart';
import 'package:evoz_web/view/produtos/page/combo/combo_alter_page_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComboListPageView extends StatelessWidget {
  ComboListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ComboController();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: FloatingActionButton(
            onPressed: (){
              controller.clearAll();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext) => ComboAlterPageView(controller: controller,))
              );
            },
            child: Icon(Icons.add)
        ),
      ),
      body: Column(
        children: [
          CustomTitle(title: "Combos"),
          Divider(),
          FutureBuilder(
            future: controller.getAll(),
            builder: (context, snapshot) {
              return Expanded(child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                builder: (context) {
                  return ListView.builder(
                      itemCount: controller.cabCombos.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            controller.setCombo(controller.cabCombos[index]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext) => ComboAlterPageView(controller: controller,))
                            );
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Icon(Icons.dashboard),
                                  ),
                                  SizedBox(width: 8,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${controller.cabCombos[index].descricao}"),
                                      Row(
                                        children: [
                                          Text("Data: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(FormatingDate.getDate(
                                              controller.cabCombos[index].dataCriacao,
                                              FormatingDate.formatDDMMYYYYHHMM)
                                          )
                                        ],
                                      ),
                                      Text(UtilBrasilFields.obterReal(controller.cabCombos[index].valorTotal!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green
                                        )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                  );
                }
              ));
            },)
        ],
      ),
    );
  }

}
