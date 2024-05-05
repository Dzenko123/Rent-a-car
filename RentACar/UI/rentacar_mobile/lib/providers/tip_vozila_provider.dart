import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class TipVozilaProvider extends BaseProvider<TipVozila> {
  TipVozilaProvider() : super("TipVozila");

  @override
  TipVozila fromJson(data) {
    // TODO: implement fromJson
    return TipVozila.fromJson(data);
  }
}
