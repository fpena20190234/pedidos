import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.

class Services_valor_combustibles {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/ValorCombustibles.php';
  static const _GET_ULTIMO = 'GET_ULTIMO';


  // Method to add Consumos to the database...
  static Future<String> getUltimo() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ULTIMO;

      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode || 500 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}