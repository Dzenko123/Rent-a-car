import 'package:rentacar_admin/models/recenzije.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class RecenzijaProvider extends BaseProvider<Recenzije> {
  RecenzijaProvider() : super("Recenzije");
  @override
  Recenzije fromJson(data) {
    //     // TODO: implement fromJson
    return Recenzije.fromJson(data);
  }
}
