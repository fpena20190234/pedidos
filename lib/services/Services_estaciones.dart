import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../models/Estaciones.dart';

class Services_estaciones {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Estaciones.php';
  static const _GET_ALL_ACTION = 'GET_ALL';

  static Future<List<Estaciones>> getEstaciones() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Estaciones> list = parseResponse(response.body);
        print('getEstaciones Response: entra0');
        return list;
      } else {
        print('getEstaciones Response: entra1');
        return List<Estaciones>();
      }
    } catch (e) {
      print('getEstaciones Response: entra2' + e.toString());
      return List<Estaciones>(); // return an empty list on exception/error
    }
  }

  static List<Estaciones> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Estaciones>((json) => Estaciones.fromJson(json)).toList();
  }


}