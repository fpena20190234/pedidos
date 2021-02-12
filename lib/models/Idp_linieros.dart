class IdpLinieros {
  String liniero;
  String vehiculo;
  String horas;

  IdpLinieros({this.liniero, this.vehiculo,this.horas});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "liniero" : liniero,
      "vehiculo" : vehiculo,
      "horas" : horas,
    };
  }
}