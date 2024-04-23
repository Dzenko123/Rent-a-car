import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class VozilaProvider extends BaseProvider<Vozilo> {
  static const String _baseUrl = String.fromEnvironment("baseUrl",
      defaultValue: "https://localhost:7284/");
  static const String _endpoint = "Vozila";

  VozilaProvider() : super(_endpoint);

  @override
  Vozilo fromJson(data) {
    return Vozilo.fromJson(data);
  }

  Future<Vozilo> activate(int id) async {
    final url = '$_baseUrl$_endpoint/$id/activate';
    final headers = createHeaders();
    var uri = Uri.parse(url);

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Aktivacija nije uspjela.");
    }
  }

  @override
  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 500) {
      throw Exception("Vozilo je rezervisano! (status:${response.statusCode})");
    } else {
      throw Exception("Active state machine or docker not running! (status:${response.statusCode})");
    }
  }

  Future<Vozilo> hide(int id) async {
    final url = '$_baseUrl$_endpoint/$id/hide';
    final headers = createHeaders();
    var uri = Uri.parse(url);

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Skrivanje nije uspjelo.");
    }
  }

  @override
  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    print("poslali ste: $username, $password");
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  @override
  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
