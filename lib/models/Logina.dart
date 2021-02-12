class Logina {
  String usuario;
  String fechac;
  String supervisord;
  String supervisore;
  String id_empresa;
  String bodega;
  Logina({this.usuario, this.fechac, this.supervisord, this.supervisore, this.id_empresa, this.bodega});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "usuario" : usuario,
      "fechac" : fechac,
      "supervisord" : supervisord,
      "supervisore" : supervisore,
      "id_empresa": id_empresa,
      "bodega": bodega,

    };
  }
}