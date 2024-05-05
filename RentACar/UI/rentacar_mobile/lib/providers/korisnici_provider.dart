import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/uloge.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KorisniciProvider extends BaseProvider<Korisnici> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "https://10.0.2.2:7284/");

  static const String _endpoint = "Korisnici";

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

  Future<int> getLoged(String username, String password) async {
    var url =
        "$_baseUrl$_endpoint/GetLoged?username=$username&password=$password";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unexpected error occurred while logging in");
    }
  }
}
