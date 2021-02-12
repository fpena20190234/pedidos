import 'package:cook/models/Idp_linieros.dart';
import 'package:cook/models/Idp_vehiculos.dart';
import 'package:cook/models/Linieros.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import '../models/Logina.dart'; //import model class
import 'dart:io';
import 'dart:async';

class MemoDbProvider{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"deltec05.db"); //create path to database

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Login(
          id INTEGER PRIMARY KEY,
          usuario TEXT,
          fechac TEXT,
          supervisore TEXT,
          supervisord TEXT,
          id_empresa TEXT,
          bodega TEXT
          )"""
          );


          await db.execute("""
          CREATE TABLE Linieros(
          id INTEGER PRIMARY KEY,
          liniero TEXT,
          vehiculo TEXT,
          horas TEXT
          )"""
          );

        });
  }

  Future<int> addItem(Logina item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("Login", item.toMap(), //toMap() function from Logina
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Logina>> fetchLogin() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Login"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Logina(
        usuario: maps[i]['usuario'],
        fechac: maps[i]['fechac'],
        supervisore: maps[i]['supervisore'],
        supervisord: maps[i]['supervisord'],
        id_empresa: maps[i]['id_empresa'],
        bodega: maps[i]['bodega'],

      );
    });
  }

  Future<int> deleteMemo() async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Login", //table name
        //where: "usuario = '?'",
        //whereArgs: [usuario] // use whereArgs to avoid SQL injection
    );

    return result;
  }


  Future<int> updateMemo(String usuario, Logina item) async{ // returns the number of rows updated
    final db = await init();

    int result = await db.update(
        "Login",
        item.toMap(),
        where: "usuario = '"+ usuario+"'"
    );
    return result;
  }

  //MANEJADOR DE LA TABLA DE LINIEROS
  Future<int> addLiniero(IdpLinieros idpLinieros) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("Linieros", idpLinieros.toMap(), //toMap() function from Logina
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }
  Future<int> deleteLinieros() async{ //returns number of items deleted
    final db = await init();
    int result = await db.delete(
      "Linieros", //table name
    );
    return result;
  }

  Future<List<IdpLinieros>> fetchIdpLinieros() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Linieros"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return IdpLinieros(
        liniero: maps[i]['liniero'],
        vehiculo: maps[i]['vehiculo'],
        horas: maps[i]['horas'],

      );
    });
  }

  /*Future<List<IdpVehiculos>> fetchIdpVehiculos() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Vehiculos"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return IdpVehiculos(
        alias: maps[i]['vehiculo'],
      );
    });
  }

  //MANEJADOR DE LA TABLA DE VEHICULOS
  Future<int> addVehiculos(IdpVehiculos idpVehiculos) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("Vehiculos", idpVehiculos.toMap(), //toMap() function from Logina
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }
  Future<int> deleteVehiculos() async{ //returns number of items deleted
    final db = await init();
    int result = await db.delete(
      "Vehiculos", //table name
    );
    return result;
  }
*/
  //MANEJADOR DE LOS SUPERVISORES

  Future<int> updateSupervisores(String usuario, Logina item) async{ // returns the number of rows updated
    final db = await init();

    int result = await db.update(
        "Login",
        item.toMap(),
        where: "usuario = '?'",
        whereArgs: [usuario]
    );
    return result;
  }
}