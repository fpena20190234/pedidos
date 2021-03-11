import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import '../models/Employee.dart';

class Services_usuarios {
  // static const ROOT = 'http://18.223.233.247/prueba/webservice/Usuarios.php';
  static const ROOT =
      'https://counter.mafasof.com/api/web/index.php?r=customers%2Findex';
  // static const ROOT_PASS =
  // 'http://18.223.233.247/prueba/controllers/UserController.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';
  static const _LOGIN_ACTION = 'GET_LOGIN';

  // Method to create the table Employees.
// Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        print('getEmployees Response: entra0');
        return list;
      } else {
        print('getEmployees Response: entra1');
        return List<Employee>();
      }
    } catch (e) {
      print('getEmployees Response: entra2' + e.toString());
      return List<Employee>(); // return an empty list on exception/error
    }
  }

  static Future<String> loginEmployee(String username, String password) async {
    try {
      // Map<String, String> headers = {"Accept": "application/json"};
      // String json = "{'username': username, 'password': password}";
      // make POST request
      final auth = "Basic " + base64.encode(utf8.encode("$username:$password"));
      var headers = {
        'Authorization': auth,
        'Cookie':
            '_csrf=e29d893aa61752a671cc6f4e1561bef976efd905a9cf69349179897130cfd07aa%3A2%3A%7Bi%3A0%3Bs%3A5%3A%22_csrf%22%3Bi%3A1%3Bs%3A32%3A%224ZsbEgZU0iK4DapVPJu3O46VBDrQk59y%22%3B%7D; PHPSESSID=tge72ddfga8lf82d9sf76d85vi'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://counter.mafasof.com/api/web/index.php?r=customers%2Findex'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      // var status_code = 0;
      if (response.statusCode == 200) {
        return "success";
        // print('ENTRA == 200');
        //  DefaultPage();
        // print(await response.stream.bytesToString());
      } else {
        // print('NO ENTRA == 200');
        return "error";
        // print(response.reasonPhrase);
      }
      // return status_code;
      // final response = await http.get(ROOT, headers: {
      //   "Accept": "application/json",
      //   'username': username,
      //   'password': password
      // });
      // check the status code for the result
      // int statusCode = response.statusCode;
      // print(statusCode);
      // this API passes back the id of the new item added to the body
      // String body = response.body;
      // print(body);
      // {
      //   "title": "Hello",
      //   "body": "body text",
      //   "userId": 1,
      //   "id": 101
      // }
      // var map = Map<String, dynamic>();
      // map['action'] = _LOGIN_ACTION;
      // map['username'] = email;
      // map['password'] = clave;
      // final response = await http.post(ROOT, body: map);
      // var client = http.Client();
      // try {
      //   var uriResponse = await client.get(ROOT, headers: {
      //     "Accept": "application/json",
      //     "username": username,
      //     "password": password
      //   });
      //   print(uriResponse.body);
      // } finally {
      //   client.close();
      // }

      // print('Login Response body : ${response.body}');
      // print('Login Response statusCode : ${response.statusCode}');

      // if (200 == response.statusCode || 500 == response.statusCode) {
      //   print('response  ${response.body}');

      //   return response.body;
      // } else {
      //   print('else 200 500');

      //   return "error";
      // }
    } catch (e) {
      print('catch');

      return "error";
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteEmployee Response: ${response.body}');
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
