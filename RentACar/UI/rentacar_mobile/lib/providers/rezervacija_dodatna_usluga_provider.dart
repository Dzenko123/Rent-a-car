import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class RezervacijaDodatnaUslugaProvider extends BaseProvider<RezervacijaDodatnaUsluga> {
  RezervacijaDodatnaUslugaProvider() : super("RezervacijaDodatnaUsluga");

  @override
  RezervacijaDodatnaUsluga fromJson(data) {
    // TODO: implement fromJson
    return RezervacijaDodatnaUsluga.fromJson(data);
  }
}