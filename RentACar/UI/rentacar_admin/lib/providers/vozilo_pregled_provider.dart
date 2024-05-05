import 'package:rentacar_admin/models/vozilo_pregled.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class VoziloPregledProvider extends BaseProvider<VoziloPregled> {
  VoziloPregledProvider() : super("VoziloPregled");

  @override
  VoziloPregled fromJson(data) {
    // TODO: implement fromJson
    return VoziloPregled.fromJson(data);
  }
}
