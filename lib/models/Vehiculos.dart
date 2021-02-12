class Vehiculos {
  String id;
  String alias;
  String placa;

  Vehiculos({this.id, this.alias,this.placa});

  factory Vehiculos.fromJson(Map<String, dynamic> json) {
    return Vehiculos(
      id: (json['id_vehiculo']) as String,
      alias: json['alias'] as String,
      placa: json['placa'] as String,
    );
  }
}