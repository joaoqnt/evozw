import 'package:evoz_web/repository/dashboard_repository.dart';
import 'package:mobx/mobx.dart';

import '../util/FormatDate.dart';

part 'dashboard_controller.g.dart';

class DashboardController = _DashboardController with _$DashboardController;

abstract class _DashboardController with Store{
  final _repository = DashboardRepository();
  @observable
  List<Map<String,dynamic>> diasVenda = ObservableList.of({});
  @observable
  List<Map<String,dynamic>> produtosVenda = ObservableList.of({});
  @observable
  List<Map<String,dynamic>> horariosVenda = ObservableList.of({});
  @observable
  double ticketMedio = 0;
  @observable
  String vendedorDestaque = '';
  @observable
  String categoriaDestaque = '';
  @observable
  String? dtInicial;
  @observable
  String? dtFinal;
  @observable
  DateTime? _startDate;
  @observable
  DateTime? _endDate;

  @action
  Future<List<Map<String,dynamic>>> getAllDashs() async{
    dtInicial = FormatingDate.getDateToInsert(_startDate??DateTime.now().subtract(Duration(days: 61)),data: true);
    dtFinal = FormatingDate.getDateToInsert(_endDate??DateTime.now(),data: true);
    try{
      diasVenda = await _repository.getDiasVenda(dtInicial!, dtFinal!);
      produtosVenda = await _repository.getProdutosVenda(dtInicial!, dtFinal!);
      horariosVenda = await _repository.getHorariosVenda(dtInicial!, dtFinal!);
      ticketMedio = await _repository.getTicketMedio(dtInicial!, dtFinal!);
      categoriaDestaque = await _repository.getCategoriaVenda(dtInicial!, dtFinal!);
      vendedorDestaque = await _repository.getUsuarioVenda(dtInicial!, dtFinal!);
      horariosVenda.sort((a, b) => a['data_pedido'].compareTo(b['data_pedido']));
    }catch(e){

    }
    dtInicial = FormatingDate.getDate(_startDate??DateTime.now().subtract(Duration(days: 61)),FormatingDate.formatDDMMYYYY);
    dtFinal = FormatingDate.getDate(_endDate??DateTime.now(),FormatingDate.formatDDMMYYYY);
    return diasVenda;
  }
}