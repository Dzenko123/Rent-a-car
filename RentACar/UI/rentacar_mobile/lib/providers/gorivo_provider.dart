import 'dart:convert';

import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class GorivoProvider extends BaseProvider<Gorivo> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "https://10.0.2.2:7284/");
  static const String _endpoint = "Gorivo";
  GorivoProvider() : super("Gorivo");

  @override
  Gorivo fromJson(data) {
    // TODO: implement fromJson
    return Gorivo.fromJson(data);
  }

  Future<List<Gorivo>> getAll() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return List<Gorivo>.from(data.map((item) => Gorivo.fromJson(item)));
    } else {
      throw Exception("Nepoznato!");
    }
  }
  Future<Gorivo?> getById(int id) async {
    try {
      String url = '$_baseUrl$_endpoint/$id';
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Failed to load gorivo');
      }
    } catch (e) {
      print('Error fetching gorivo by ID: $e');
      return null;
    }
  }
  Future<List<Gorivo>> getAllLowerCase() async {
    var goriva = await getAll();
    return goriva.map((gorivo) => gorivo.toLowerCase()).toList();
  }
}
