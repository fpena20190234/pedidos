import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../models/Preoperacional.dart';
import '../models/question_model.dart';

class Services_preoperacional {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Preoperacional.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_PREOPERACIONAL_ACTION = 'ADD_PREOPERACIONAL';
  static const _UPDATE_TANQUEO_ACTION = 'UPDATE_CONSUMO';
  static const _DELETE_TANQUEO_ACTION = 'DELETE_CONSUMO';

// Method to create the table Consumoss.
  static Future<List<Preoperacional>> getPreoperacional(String usuario) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['idusuario'] = usuario;
    print("Preoperaciones"+usuario);
      final response = await http.post(ROOT, body: map);

      if (200 == response.statusCode || 500 == response.statusCode) {
        print(response.body);

        List<Preoperacional> list = parseResponse(response.body);
        return list;
      } else {
        return List<Preoperacional>();
      }
    } catch (e) {
      return List<Preoperacional>(); // return an empty list on exception/error
    }
  }

  static List<Preoperacional> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Preoperacional>((json) => Preoperacional.fromJson(json)).toList();
  }

  // Method to add Consumos to the database...
  static Future<String> addPreoperacional(String conductor, String vehiculo, String fecha, String km, List<QuestionModel> questions,String tieneLicencia,String tieneMatricula,String tieneSeguroV, String tieneSeguroP, String sfecha_seguro, String sfecha_licencia, String idusuario) async {

    //=========================LOS DATOS DEL TERCER FORMULARIO===============================
    String jsonp = "[";
    questions.forEach((item) {
      jsonp +='{"i": "' + item.id + '", "r": "' + item.answer + '"},';
    });
    jsonp = jsonp.substring(0, jsonp.length -1);
    jsonp += "]";

    String jsond = '{"tieneLicencia": "' + tieneLicencia + '", "tieneMatricula": "' + tieneMatricula + '", "tieneSeguroV": "'  + tieneSeguroV + '", "tieneSeguroP": "' +tieneSeguroP + '","fecha_seguro" : "' + sfecha_seguro + '", "fecha_licencia" : "' + sfecha_licencia +   '"}';

    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_PREOPERACIONAL_ACTION;
      map['jsonp'] = jsonp;
      map['jsond'] = jsond;
      map['vehiculo'] = vehiculo;
      map['conductor'] = conductor;
      map['fecha'] = fecha;
      map['km'] = km;
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
}