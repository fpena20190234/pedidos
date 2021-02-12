import 'dart:convert';
import 'dart:io';
import 'package:cook/models/Idp_linieros.dart';
import 'package:cook/models/Idp_vehiculos.dart';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import 'package:path_provider/path_provider.dart';
import '../models/Idp.dart';


class Services_idp {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Idp.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_IDP_ACTION = 'ADD_IDP';
  static const _UPDATE_IDP_ACTION = 'UPDATE_IDP';
  static const _DELETE_IDP_ACTION = 'DELETE_IDP';


  static Future<List<Idp>> getIDP(String usuario) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['idusuario'] = usuario;
      print("Preoperaciones"+usuario);
      final response = await http.post(ROOT, body: map);

      if (200 == response.statusCode || 500 == response.statusCode) {
        print(response.body);

        List<Idp> list = parseResponse(response.body);
        return list;
      } else {
        return List<Idp>();
      }
    } catch (e) {
      return List<Idp>(); // return an empty list on exception/error
    }
  }

  static List<Idp> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Idp>((json) => Idp.fromJson(json)).toList();
  }

  static Future<String> addIdp(String fecha, String ciudad, String proyecto,String incidencia, String obs, String bodega,String supervisord,String supervisore, String id_empresa,List<IdpLinieros> linieros, var firma, String idusuario) async {

    //=========================LOS DATOS DEL TERCER FORMULARIO===============================
    print("-fecha" + fecha + ", ciudad " +  ciudad + ", proyecto "+ proyecto +", incidencia " + incidencia + ", bodega " + bodega + ", obs "+ obs +  ", supervisord " + supervisord + ", supervisore" +  supervisore + ", id_empresa"+ id_empresa + ", idusuario"+ idusuario);

    String jsonp = "[";
    linieros.forEach((item) {
      jsonp +='{"p": "' + item.liniero + '","v":"'+ item.vehiculo +'","h":"'+ item.horas +'"},';
    });
    jsonp = jsonp.substring(0, jsonp.length -1);
    jsonp += "]";
    print("jsonp=>" + jsonp);

    //File firmas = File(firma.path);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/firma.png';
    final imageFile = await new File(filePath);
    final result = await imageFile.writeAsBytes(firma);

    //final imageFile = File("Some path and filename"); // You can use the path_provider package to locate the right path.
    //final result = await imageFile.writeAsBytes(byteList);


    String firmaRuta = result.path;

    try {

      final request = await http.MultipartRequest('POST', Uri.parse(ROOT));
      request.files.add(await http.MultipartFile.fromPath('firma', firmaRuta));
      request.fields['action'] = _ADD_IDP_ACTION;
      request.fields['jsonp'] = jsonp;
      request.fields['fecha'] = fecha;
      request.fields['ciudad'] = ciudad;
      request.fields['incidencia'] = incidencia;
      request.fields['obs'] = obs;
      request.fields['supervisord'] = supervisord;
      request.fields['supervisore'] = supervisore;
      request.fields['proyecto'] = proyecto;
      request.fields['idusuario'] = idusuario;
      request.fields['id_empresa'] = id_empresa;
      request.fields['bodega'] = bodega;

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      print("res "+ response.body);
      return response.body;

    } catch (e) {
      return "error";
    }
  }

}