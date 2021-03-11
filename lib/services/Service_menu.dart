import 'dart:convert';
// import 'package:cook/Widgets/menu_item.dart';
// import 'package:cook/models/Bodegas.dart';
// import 'package:cook/models/Contratos.dart';
// import 'package:cook/models/Linieros.dart';
// import 'package:cook/models/Proyectos.dart';
import 'package:cook/models/Menu.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
// import '../models/Ciudades.dart';
// import '../models/Supervisor.dart';

class Services_menu {
  static const ROOT = 'http://18.223.233.247/prueba/webservice/Menu.php';

  static const _GET_ALL_MENU = 'GET_ALL_MENU';

  static Future<List<Menu>> getMenu() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_MENU;
      // map['id_empresa'] = id_empresa;

      final response = await http.post(ROOT, body: map);
      print('getMenus Response: ${response.body}');
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Menu> list = parseResponseM(response.body);
        print('getMenus Response: entra0');
        return list;
      } else {
        print('getMenus Response: entra1');
        return List<Menu>();
      }
    } catch (e) {
      print('getCiudades Response: entra2' + e.toString());
      return List<Menu>(); // return an empty list on exception/error
    }
  }

  static List<Menu> parseResponseM(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Menu>((json) => Menu.fromJson(json)).toList();
  }

  // static Future<List<Ciudades>> getCiudades() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = _GET_ALL_CIUDADES;
  //     final response = await http.post(ROOT, body: map);
  //     print('getCiudades Response: ${response.body}');
  //     if (200 == response.statusCode || 500 == response.statusCode) {
  //       List<Ciudades> list = parseResponse(response.body);
  //       print('getCiudades Response: entra0');
  //       return list;
  //     } else {
  //       print('getCiudades Response: entra1');
  //       return List<Ciudades>();
  //     }
  //   } catch (e) {
  //     print('getCiudades Response: entra2' + e.toString());
  //     return List<Ciudades>(); // return an empty list on exception/error
  //   }
  // }

}
