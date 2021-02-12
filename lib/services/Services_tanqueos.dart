import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../models/Consumos.dart';

class Services_tanqueos {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Consumo.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_TANQUEO_ACTION = 'ADD_CONSUMO';
  static const _UPDATE_TANQUEO_ACTION = 'UPDATE_CONSUMO';
  static const _DELETE_TANQUEO_ACTION = 'DELETE_CONSUMO';

// Method to create the table Consumoss.
  static Future<List<Consumos>> getConsumoss(String usuario) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['idusuario'] = usuario;

      final response = await http.post(ROOT, body: map);

      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Consumos> list = parseResponse(response.body);
        return list;
      } else {
        return List<Consumos>();
      }
    } catch (e) {
      return List<Consumos>(); // return an empty list on exception/error
    }
  }

  static List<Consumos> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Consumos>((json) => Consumos.fromJson(json)).toList();
  }

  // Method to add Consumos to the database...
  static Future<String> addConsumos(String estacion, String vehiculo, String fecha, String km, String galones,String valor,String idusuario) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_TANQUEO_ACTION;
      map['estacion'] = estacion;
      map['vehiculo'] = vehiculo;
      map['fecha'] = fecha;
      map['km'] = km;
      map['galones'] = galones;
      map['valor'] = valor;
      map['idusuario'] = idusuario;

      final response = await http.post(ROOT, body: map);
      print('addConsumos Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Consumos in Database...
  static Future<String> updateConsumos(
      String id,String estacion, String vehiculo, String fecha, String km, String galones,String idempresa, String idusuario) async {
    try {
      var map = Map<String, dynamic>();
      map['id'] = _UPDATE_TANQUEO_ACTION;
      map['estacion'] = estacion;
      map['vehiculo'] = vehiculo;
      map['fecha'] = fecha;
      map['km'] = km;
      map['galones'] = galones;
      map['idempresa'] = idempresa;
      map['idusuario'] = idusuario;
      final response = await http.post(ROOT, body: map);
      print('updateConsumos Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Consumos from Database...
  static Future<String> deleteConsumos(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_TANQUEO_ACTION;
      map['id'] = id;
      final response = await http.post(ROOT, body: map);
      print('deleteConsumos Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}