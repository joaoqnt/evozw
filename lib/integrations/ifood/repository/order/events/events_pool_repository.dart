import 'package:dio/dio.dart';
import 'package:evoz_web/integrations/ifood/repository/ifood_repository.dart';
import 'package:evoz_web/util/global.dart';

class EventsPoolRepository extends IfoodRepository{
  Future<String> eventsPooling() async{
    String token = '';
    Response response = await apiIfood(
        'events:pool',
        Global().iFood!,
        // header: {"Authorization": "Bearer ${Global().iFood?.acessToken}"}
    );
    // print(response.statusCode);
    return token;
  }
}