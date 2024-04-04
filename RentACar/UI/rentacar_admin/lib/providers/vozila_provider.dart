import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class VozilaProvider extends BaseProvider<Vozilo> {
  VozilaProvider() : super("Vozila");

  @override
  Vozilo fromJson(data) {
    // TODO: implement fromJson
    return Vozilo.fromJson(data);
  }
}
