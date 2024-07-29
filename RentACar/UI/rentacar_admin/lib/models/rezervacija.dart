import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/vozila.dart';

part 'rezervacija.g.dart';

@JsonSerializable()
class Rezervacija {
  int? rezervacijaId;
  int? korisnikId;
  int? voziloId;
  int? gradId;
  DateTime? pocetniDatum;
  DateTime? zavrsniDatum;
  double? totalPrice;
  bool? zahtjev;

  Vozilo? vozilo;
  List<int>? dodatnaUslugaId;
  List<DodatnaUsluga>? dodatnaUsluga;
Korisnici? korisnik;
Grad? grad;
  Rezervacija(this.rezervacijaId, this.korisnikId, this.voziloId, this.gradId,
      this.pocetniDatum, this.zavrsniDatum,this.totalPrice, this.vozilo, this.dodatnaUslugaId,this.zahtjev, [this.dodatnaUsluga,  this.korisnik, this.grad]);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
