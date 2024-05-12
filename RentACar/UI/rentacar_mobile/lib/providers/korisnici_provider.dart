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

  Future<Korisnici> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unexpected error occurred while fetching user data");
    }
  }

  Future<void> updatePasswordAndUsername(int id, String oldPassword,
      String korisnickoIme, String password, String passwordPotvrda) async {
    var url =
        "$_baseUrl$_endpoint/UpdatePasswordAndUsername?id=$id&oldPassword=$oldPassword";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var requestBody = jsonEncode({
      'korisnickoIme': korisnickoIme,
      'password': password,
      'passwordPotvrda': passwordPotvrda
    });

    var response = await http.put(uri, headers: headers, body: requestBody);

    if (!isValidResponse(response)) {
      throw Exception(
          "Unexpected error occurred while updating password and username");
    }
  }

  Future<void> registerUser({
    required String ime,
    required String prezime,
    required String email,
    required String telefon,
    required String korisnickoIme,
    required String password,
    required String passwordPotvrda,
  }) async {
    // Pripremi podatke o novom korisniku koji ćemo poslati na backend
    var newUser = {
      'Ime': ime,
      'Prezime': prezime,
      'Email': email,
      'Telefon': telefon,
      'KorisnickoIme': korisnickoIme,
      'Password': password,
      'PasswordPotvrda': passwordPotvrda,
    };

    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var requestBody = jsonEncode(newUser);

    var response = await http.post(uri, headers: headers, body: requestBody);

    if (isValidResponse(response)) {
      // Uspješno dodan korisnik
      print('Korisnik uspješno dodan!');
    } else {
      // Neuspješan zahtjev, ispišimo poruku o grešci
      print('Greška prilikom dodavanja korisnika: ${response.reasonPhrase}');
    }
  }
}
