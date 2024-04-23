import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class GorivoProvider extends BaseProvider<Gorivo> {
  GorivoProvider() : super("Gorivo");

  @override
  Gorivo fromJson(data) {
    // TODO: implement fromJson
    return Gorivo.fromJson(data);
  }
}
