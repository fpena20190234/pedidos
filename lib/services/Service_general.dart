import 'dart:convert';
import 'package:cook/models/Contratos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import '../models/Ciudades.dart';

class Services_general {
  static Future<List<Contratos>> getContratos(String idusuario) async {
    try {
      var headers = {
        'Cookie':
            '_csrf=e29d893aa61752a671cc6f4e1561bef976efd905a9cf69349179897130cfd07aa%3A2%3A%7Bi%3A0%3Bs%3A5%3A%22_csrf%22%3Bi%3A1%3Bs%3A32%3A%224ZsbEgZU0iK4DapVPJu3O46VBDrQk59y%22%3B%7D; PHPSESSID=tge72ddfga8lf82d9sf76d85vi'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://counter.mafasof.com/api/web/index.php?r=empresas%2Findex-empresas'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var respuesta = '';
        respuesta = await response.stream.bytesToString();
        List<Contratos> list = parseResponseC(respuesta);
        return list;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      // print('_GET_ALL_CONTRATOSS Response: entra2' + e.toString());
      return List<Contratos>(); // return an empty list on exception/error
    }
  }

  static List<Contratos> parseResponseC(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Contratos>((json) => Contratos.fromJson(json)).toList();
  }
}
