class IdpVehiculos {
  String alias;

  IdpVehiculos({this.alias});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "vehiculo" : alias,
    };
  }

}