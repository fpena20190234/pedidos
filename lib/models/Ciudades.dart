class Ciudades {
  String id_ciudad;
  String nombre_ciudad;

  Ciudades({this.id_ciudad, this.nombre_ciudad});

  factory Ciudades.fromJson(Map<String, dynamic> json) {
    return Ciudades(
      id_ciudad: (json['id_ciudad']) as String,
      nombre_ciudad: json['nombre_ciudad'] as String,
    );
  }
}