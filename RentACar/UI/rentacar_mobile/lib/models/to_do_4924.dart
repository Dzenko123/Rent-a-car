import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/korisnici.dart';

part 'to_do_4924.g.dart';

@JsonSerializable()
class ToDo4924Model {
  int? toDo4924Id;
  String? nazivAktivnosti;
  String? opisAktivnosti;
  DateTime ? datumIzvrsenja;
  String? status;
  int? korisnikId;
  Korisnici? korisnik;

  ToDo4924Model(this.toDo4924Id, this.nazivAktivnosti, this.datumIzvrsenja,this.status, this.opisAktivnosti,this.korisnik, this.korisnikId);
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ToDo4924Model.fromJson(Map<String, dynamic> json) => _$ToDo4924ModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ToDo4924ModelToJson(this);
}