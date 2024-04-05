import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/dashboard_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);
  final _controller = DashboardController();
  final _tooltipBehavior = TooltipBehavior(enable: true,duration: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Observer(
            builder: (context) {
              return Column(
                children: [
                  CustomTitle(
                      title: "Dashboard",
                      widget: Row(
                        children: [
                          IconButton(
                              onPressed: () async{
                                // await controller.setDateIni(context);
                              },
                              icon: Icon(Icons.calendar_month)
                          ),
                          Text("${_controller.dtInicial} - ${_controller.dtFinal}")
                        ],
                      )
                  ),
                  Divider(),
                ],
              );
            }
          ),
          FutureBuilder(
              future: _controller.getAllDashs(),
              builder: (context, snapshot) {
                return Expanded(child: !snapshot.hasData ? Center(child: CircularProgressIndicator()) : Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        MediaQuery.of(context).size.width <= 650 ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _cardInfos("Ticket Médio",
                                  UtilBrasilFields.obterReal(_controller.ticketMedio)
                              ),
                              SizedBox(width: 8,),
                              _cardInfos("Mais Vendas",
                                  _controller.vendedorDestaque
                              ),
                              SizedBox(width: 8,),
                              _cardInfos("Categoria Mais Vendida",
                                  _controller.categoriaDestaque
                              ),
                            ],
                          ),
                        ) : Container(),
                        Expanded(
                          child: GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width >= 650 ? 4 : 1,
                              crossAxisSpacing: 18.0,
                              mainAxisSpacing: 18.0,
                            ),
                            children: [
                              if (MediaQuery.of(context).size.width >= 650)
                                Card(
                                  // elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cardInfos("Ticket Médio",
                                            UtilBrasilFields.obterReal(_controller.ticketMedio)
                                        ),
                                        Divider(),
                                        _cardInfos("Mais Vendas",
                                            _controller.vendedorDestaque
                                        ),
                                        Divider(),
                                        _cardInfos("Categoria Destaque",
                                            _controller.categoriaDestaque
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Card(
                                // elevation: 0,
                                child: SfCartesianChart(
                                  title: ChartTitle(text: 'Faturamento Diário',),
                                  primaryXAxis: CategoryAxis(
                                  ),
                                  enableAxisAnimation: true,
                                  series: <ChartSeries>[
                                    ColumnSeries<Map<String, dynamic>, String>(
                                      dataSource: _controller.diasVenda,
                                      xValueMapper: (Map<String, dynamic> data, _) => data["dia_da_semana"]
                                          .toString().substring(0,3),
                                      yValueMapper: (Map<String, dynamic> data, _) =>
                                          double.parse(data["total"].toString()),
                                      dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelAlignment: ChartDataLabelAlignment.auto,
                                        textStyle: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                // elevation: 0,
                                child: SfCircularChart(
                                    title: ChartTitle(text: "Cinco Produtos Mais Vendidos"),
                                    legend: Legend(
                                        isVisible: true,
                                        toggleSeriesVisibility: true,
                                        overflowMode: LegendItemOverflowMode.wrap,
                                        position: LegendPosition.bottom
                                    ),
                                    tooltipBehavior: _tooltipBehavior,
                                    series: [
                                      PieSeries<Map<String, dynamic>, String>(
                                          explode: true,
                                          explodeIndex: 0,
                                          dataSource: _controller.produtosVenda,
                                          xValueMapper: (Map<String, dynamic> data, _) => data["nome_produto"],
                                          yValueMapper: (Map<String, dynamic> data, _) => data["total_qtd"],
                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                      )
                                    ]
                                ),
                              ),
                              Card(
                                // elevation: 0,
                                child: SfCartesianChart(
                                  title: ChartTitle(text: 'Horários De Pico',),
                                  primaryXAxis: CategoryAxis(
                                  ),
                                  enableAxisAnimation: true,
                                  series: <ChartSeries>[
                                    LineSeries<Map<String, dynamic>, String>(
                                      dataSource: _controller.horariosVenda,
                                      xValueMapper: (Map<String, dynamic> data, _) => data["data_pedido"].toString(),
                                      yValueMapper: (Map<String, dynamic> data, _) =>
                                          int.parse(data["qtd_pedido"].toString()),
                                      dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelAlignment: ChartDataLabelAlignment.auto,
                                        textStyle: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              )],
                          ),
                        )
                      ],
                    );
                  }
                ));
              },
          )

        ],
      ),
    );
  }

  _cardInfos(String title, String description){
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title),
            SizedBox(height: 8,),
            Text(description,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}