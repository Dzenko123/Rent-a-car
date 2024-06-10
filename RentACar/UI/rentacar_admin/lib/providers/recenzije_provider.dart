import 'package:rentacar_admin/models/recenzije.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class RecenzijeProvider extends BaseProvider<Recenzije> {
  RecenzijeProvider() : super("Recenzije");
  @override
  Recenzije fromJson(data) {
    // TODO: implement fromJson
    return Recenzije.fromJson(data);
  }
}
