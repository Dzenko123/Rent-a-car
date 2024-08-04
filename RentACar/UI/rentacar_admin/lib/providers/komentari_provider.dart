import 'package:rentacar_admin/models/komentari.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KomentariProvider extends BaseProvider<Komentari> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "http://localhost:7284/");

  static const String _endpoint = "Komentari";

  KomentariProvider() : super(_endpoint);
  @override
  Komentari fromJson(data) {
   // TODO: implement fromJson
    return Komentari.fromJson(data);
  }

 Future<List<Komentari>> getCommentsForVehicle(int voziloId) async {
  try {
    String url = "$_baseUrl$_endpoint/VoziloId/$voziloId";
    var response = await http.get(Uri.parse(url), headers: createHeaders());
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List<dynamic>;
      var komentari = data.map((item) => fromJson(item)).toList();
      return komentari;
    } else {
      throw Exception("Nepoznato!");
    }
  } catch (e) {
    throw Exception("Greška prilikom dohvaćanja komentara: $e");
  }
}

}
