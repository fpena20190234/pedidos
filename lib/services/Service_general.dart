import 'dart:convert';
import 'package:cook/models/Bodegas.dart';
import 'package:cook/models/Contratos.dart';
import 'package:cook/models/Linieros.dart';
import 'package:cook/models/Proyectos.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import '../models/Ciudades.dart';
import '../models/Supervisor.dart';

class Services_general {
  static const ROOT = 'http://18.223.233.247/prueba/webservice/Generales.php';
  static const _GET_ALL_CIUDADES = 'GET_ALL_CIUDADES';
  static const _GET_ALL_SUPERVISORD = 'GET_ALL_SUPERVISORD';
  static const _GET_ALL_SUPERVISORE = 'GET_ALL_SUPERVISORE';
  static const _GET_ALL_LINIEROS = 'GET_ALL_LINIEROS';
  static const _GET_ALL_CONTRATOS = 'GET_ALL_CONTRATOS';
  static const _GET_ALL_PROYECTOS = 'GET_ALL_PROYECTOS';
  static const _GET_ALL_BODEGAS = 'GET_ALL_BODEGAS';

  static Future<List<Ciudades>> getCiudades() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_CIUDADES;
      final response = await http.post(ROOT, body: map);
      print('getCiudades Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Ciudades> list = parseResponse(response.body);
        print('getCiudades Response: entra0');
        return list;
      } else {
        print('getCiudades Response: entra1');
        return List<Ciudades>();
      }
    } catch (e) {
      print('getCiudades Response: entra2' + e.toString());
      return List<Ciudades>(); // return an empty list on exception/error
    }
  }

  static Future<List<Supervisor>> getSupervisorD(String id_empresa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_SUPERVISORD;
      map['id_empresa'] = id_empresa;

      final response = await http.post(ROOT, body: map);
      print('getSupervisord Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Supervisor> list = parseResponseS(response.body);
        print('getSupervisord Response: entra0');
        return list;
      } else {
        print('getSupervisord Response: entra1');
        return List<Supervisor>();
      }
    } catch (e) {
      print('getCiudades Response: entra2' + e.toString());
      return List<Supervisor>(); // return an empty list on exception/error
    }
  }

  static Future<List<Supervisor>> getSupervisorE(String id_empresa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_SUPERVISORE;
      map['id_empresa'] = id_empresa;

      final response = await http.post(ROOT, body: map);
      print('getSupervisorE Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Supervisor> list = parseResponseS(response.body);
        print('getSupervisorE Response: entra0');
        return list;
      } else {
        print('getSupervisorE Response: entra1');
        return List<Supervisor>();
      }
    } catch (e) {
      print('getCiudades Response: entra2' + e.toString());
      return List<Supervisor>(); // return an empty list on exception/error
    }
  }

  static Future<List<Bodegas>> getBodegas(String id_empresa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_BODEGAS;
      map['id_empresa'] = id_empresa;

      final response = await http.post(ROOT, body: map);
      print('getBODEGAS Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Bodegas> list = parseResponseB(response.body);
        print('getBODEGAS Response: entra0');
        return list;
      } else {
        print('getBodegas Response: entra1');
        return List<Bodegas>();
      }
    } catch (e) {
      // print('getLINIEROS Response: entra2' + e.toString());
      return List<Bodegas>(); // return an empty list on exception/error
    }
  }

  static Future<List<Linieros>> getLinieros(String id_empresa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_LINIEROS;
      map['id_empresa'] = id_empresa;

      final response = await http.post(ROOT, body: map);
      // print('getLINIEROS Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Linieros> list = parseResponseL(response.body);
        // print('getLINIEROS Response: entra0');
        return list;
      } else {
        // print('getLINIEROS Response: entra1');
        return List<Linieros>();
      }
    } catch (e) {
      // print('getLINIEROS Response: entra2' + e.toString());
      return List<Linieros>(); // return an empty list on exception/error
    }
  }

  static Future<List<Contratos>> getContratos(String idusuario) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_CONTRATOS;
      map['idusuario'] = idusuario;

      final response = await http.post(ROOT, body: map);
      // print('_GET_ALL_CONTRATOS Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Contratos> list = parseResponseC(response.body);
        // print('_GET_ALL_CONTRATOS Response: entra0');
        return list;
      } else {
        // print('_GET_ALL_CONTRATOSS Response: entra1');
        return List<Contratos>();
      }
    } catch (e) {
      // print('_GET_ALL_CONTRATOSS Response: entra2' + e.toString());
      return List<Contratos>(); // return an empty list on exception/error
    }
  }

  static Future<List<Proyectos>> getProyectos(String id_empresa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_PROYECTOS;
      map['id_empresa'] = id_empresa;
      print("id_empresa" + id_empresa);
      final response = await http.post(ROOT, body: map);
      // print('_GET_ALL_PROYECTO Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Proyectos> list = parseResponseP(response.body);
        // print('_GET_ALL_PROYECTOS Response: entra0');
        return list;
      } else {
        // print('_GET_ALL_PROYECTOS Response: entra1');
        return List<Proyectos>();
      }
    } catch (e) {
      // print('_GET_ALL_PROYECTOS Response: entra2' + e.toString());
      return List<Proyectos>(); // return an empty list on exception/error
    }
  }

  static List<Ciudades> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Ciudades>((json) => Ciudades.fromJson(json)).toList();
  }

  static List<Supervisor> parseResponseS(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Supervisor>((json) => Supervisor.fromJson(json)).toList();
  }

  static List<Linieros> parseResponseL(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Linieros>((json) => Linieros.fromJson(json)).toList();
  }

  static List<Bodegas> parseResponseB(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Bodegas>((json) => Bodegas.fromJson(json)).toList();
  }

  static List<Contratos> parseResponseC(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Contratos>((json) => Contratos.fromJson(json)).toList();
  }

  static List<Proyectos> parseResponseP(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Proyectos>((json) => Proyectos.fromJson(json)).toList();
  }
}
