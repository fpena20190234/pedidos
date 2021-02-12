class Supervisor {
  String id_usuario;
  String full_nombre;

  Supervisor({this.id_usuario, this.full_nombre});

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id_usuario: (json['id_usuario']) as String,
      full_nombre: json['full_nombre'] as String,
    );
  }
}