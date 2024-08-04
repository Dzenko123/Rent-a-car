import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GradProvider extends BaseProvider<Grad> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:7284/");

  static const String _endpoint = "Grad";
  GradProvider() : super("Grad");

  @override
  Grad fromJson(data) {
    // TODO: implement fromJson
    return Grad.fromJson(data);
  }

  Future<Grad?> getById(int id) async {
    try {
      String url = '$_baseUrl$_endpoint/$id';
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      print('Error fetching city by ID: $e');
      return null;
    }
  }
}
