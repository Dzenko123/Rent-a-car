import 'package:rentacar_admin/models/kontakt.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class KontaktProvider extends BaseProvider<Kontakt> {
  KontaktProvider() : super("Kontakt");

  @override
  Kontakt fromJson(data) {
    // TODO: implement fromJson
    return Kontakt.fromJson(data);
  }
}
