
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/uloge.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    var korisnik = Korisnici.fromJson(data);
    if (data['korisniciUloge'] != null) {
      korisnik.uloge = List<Uloge>.from(
          data['korisniciUloge'].map((x) => Uloge.fromJson(x['uloga'])));
    }
    return korisnik;
  }
}
