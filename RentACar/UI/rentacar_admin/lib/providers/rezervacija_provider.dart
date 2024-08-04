import 'dart:convert';

import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijaProvider extends BaseProvider<Rezervacija> {
   static const String _baseUrl = String.fromEnvironment("baseUrl",
      defaultValue: "http://localhost:7284/");
  static const String _endpoint = "Rezervacija";
  RezervacijaProvider() : super("Rezervacija");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<bool> potvrdiOtkazivanje(int rezervacijaId) async {
    var url = "$_baseUrl$_endpoint/Potvrda/$rezervacijaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      return true;
    } else {
      throw Exception("Unexpected error occurred while confirming the reservation");
    }
  }

  Future<bool> provjeriKoristenjeGrad(int gradId) async {
  try {
    String url = '$_baseUrl$_endpoint/GradIsInUse/$gradId';
    var response = await http.get(Uri.parse(url), headers: createHeaders());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Greška prilikom provjere korištenja grada');
    }
  } catch (e) {
    print('Greška prilikom provjere korištenja grada: $e');
    return true;
  }
}

Future<bool> provjeriKoristenjeUsluga(int uslugaId) async {
  try {
    String url = '$_baseUrl$_endpoint/DodatnaUslugaIsInUse/$uslugaId';
    var response = await http.get(Uri.parse(url), headers: createHeaders());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Greška prilikom provjere korištenja usluge');
    }
  } catch (e) {
    print('Greška prilikom provjere korištenja usluge: $e');
    return true;
  }
}

}
