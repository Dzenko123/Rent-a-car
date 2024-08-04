import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RezervacijaProvider extends BaseProvider<Rezervacija> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:7284/");

  static const String _endpoint = "Rezervacija";

  RezervacijaProvider() : super("Rezervacija");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<List<Rezervacija>> getByKorisnikId(int korisnikId) async {
    try {
      String url = "$_baseUrl$_endpoint/KorisnikId/$korisnikId";
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var rezervacije = data.map((item) => fromJson(item)).toList();
        return rezervacije;
      } else {
        throw Exception("Nepoznato!");
      }
    } catch (e) {
      throw Exception("Greška prilikom dohvaćanja komentara: $e");
    }
  }

  Future<Rezervacija> insertRezervacijaWithDodatneUsluge(Rezervacija rezervacija) async {
    try {
      String url = "$_baseUrl$_endpoint/InsertWithDodatneUsluge";
      var response = await http.post(
        Uri.parse(url),
        headers: createHeaders(),
        body: jsonEncode(rezervacija.toJson()),
      );

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Nepoznato!");
      }
    } catch (e) {
      throw Exception("Greška prilikom kreiranja rezervacije: $e");
    }
  }
  Future<List<Rezervacija>> recommend(int voziloId) async {
    try {
      String url = "$_baseUrl$_endpoint/recommend/$voziloId";
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var rezervacije = data.map((item) => fromJson(item)).toList();
        return rezervacije;
      } else {
        throw Exception("Nepoznato!");
      }
    } catch (e) {
      throw Exception("Greška prilikom dohvaćanja preporučenih rezervacija: $e");
    }
  }
  Future<bool> cancelReservation(int reservationId) async {
    try {
      String url = "$_baseUrl$_endpoint/Otkazivanje/$reservationId";
      var response = await http.post(
        Uri.parse(url),
        headers: createHeaders(),
      );

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return data as bool;
      } else {
        throw Exception("Nepoznato!");
      }
    } catch (e) {
      throw Exception("Greška prilikom otkazivanja rezervacije: $e");
    }
  }

}
