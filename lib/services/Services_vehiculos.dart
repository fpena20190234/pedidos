import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../models/Vehiculos.dart';

class Services_vehiculos {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Vehiculo.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_PREOPERACIONAL_ACTION = 'GET_ALL_PREOPERACIONAL';

  static Future<List<Vehiculos>> getVehiculos() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getVehiculos Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Vehiculos> list = parseResponse(response.body);
        print('getVehiculos Response: entra0');
        return list;
      } else {
        print('getVehiculos Response: entra1');
        return List<Vehiculos>();
      }
    } catch (e) {
      print('getVehiculos Response: entra2' + e.toString());
      return List<Vehiculos>(); // return an empty list on exception/error
    }
  }

  static Future<String> getVehiculosPreoperacional(String vehiculo) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_PREOPERACIONAL_ACTION;
      map['vehiculo'] = vehiculo;

      final response = await http.post(ROOT, body: map);
      print('getVehiculos Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        return response.body;
      } else {
        print('getVehiculos Response: entra1');
        return 'Error';
      }
    } catch (e) {
      return 'Error'; // return an empty list on exception/error
    }
  }

  static List<Vehiculos> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Vehiculos>((json) => Vehiculos.fromJson(json)).toList();
  }


}