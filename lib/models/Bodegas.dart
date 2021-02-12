class Bodegas {
  String id_usuario;
  String full_nombre;

  Bodegas({this.id_usuario, this.full_nombre});

  factory Bodegas.fromJson(Map<String, dynamic> json) {
    return Bodegas(
      id_usuario: (json['id_usuario']) as String,
      full_nombre: json['full_nombre'] as String,
    );
  }
}