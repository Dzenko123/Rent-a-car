import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DodatnaUslugaProvider extends BaseProvider<DodatnaUsluga>{
  static const String _baseUrl =
  String.fromEnvironment("baseUrl", defaultValue: "https://10.0.2.2:7284/");

  static const String _endpoint = "DodatnaUsluga";
  DodatnaUslugaProvider() : super("DodatnaUsluga");
  @override
  DodatnaUsluga fromJson(data) {
    // TODO: implement fromJson
    return DodatnaUsluga.fromJson(data);
  }
  Future<DodatnaUsluga?> getById(int id) async {
    try {
      String url = '$_baseUrl$_endpoint/$id';
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Failed to load dodatna usluga');
      }
    } catch (e) {
      print('Error fetching dodatna usluga by ID: $e');
      return null;
    }
  }
}