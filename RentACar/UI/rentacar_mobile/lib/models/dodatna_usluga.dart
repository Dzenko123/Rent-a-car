import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
part 'dodatna_usluga.g.dart';

@JsonSerializable()
class DodatnaUsluga{
int? dodatnaUslugaId;
String? naziv;
double? cijena;
DodatnaUsluga({
  this.dodatnaUslugaId,
  this.naziv,
  this.cijena,
});/// A necessary factory constructor for creating a new User instance
/// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
/// The constructor is named after the source class, in this case, User.
factory DodatnaUsluga.fromJson(Map<String, dynamic> json) => _$DodatnaUslugaFromJson(json);

/// `toJson` is the convention for a class to declare support for serialization
/// to JSON. The implementation simply calls the private, generated
/// helper method `_$UserToJson`.
Map<String, dynamic> toJson() => _$DodatnaUslugaToJson(this);
}