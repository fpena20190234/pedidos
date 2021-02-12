class Estaciones {
  String id;
  String nombre_estacion;

  Estaciones({this.id, this.nombre_estacion});

  factory Estaciones.fromJson(Map<String, dynamic> json) {
    return Estaciones(
      id: (json['id_estacion_servicio']) as String,
      nombre_estacion: json['nombre_estacion'] as String,
    );
  }
}