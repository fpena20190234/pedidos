class Preoperacional {
  String id_preoperacional;
  String fecha;
  String alias;
  String nombre_usuario;

  Preoperacional({this.id_preoperacional, this.fecha,this.alias,this.nombre_usuario});

  factory Preoperacional.fromJson(Map<String, dynamic> json) {
    return Preoperacional(
      id_preoperacional: json['id_preoperacional'] as String,
      fecha: json['fecha'] as String,
      alias: json['alias'] as String,
      nombre_usuario: json['nombre_usuario'] as String
    );
  }
}