class Linieros {
  String id_usuario;
  String full_nombre;

  Linieros({this.id_usuario, this.full_nombre});

  factory Linieros.fromJson(Map<String, dynamic> json) {
    return Linieros(
      id_usuario: (json['id_usuario']) as String,
      full_nombre: json['full_nombre'] as String,
    );
  }

}