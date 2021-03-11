class Contratos {
  int id_empresa;
  String nombre_empresa;
  String telefono;
  String logo;
  String direccion;

  Contratos(
      {this.id_empresa,
      this.nombre_empresa,
      this.telefono,
      this.logo,
      this.direccion});

  factory Contratos.fromJson(Map<String, dynamic> json) {
    return Contratos(
      id_empresa: (json['id_empresa']),
      nombre_empresa: json['nombre_empresa'] as String,
      telefono: json['telefono'] as String,
      logo: json['logo'] as String,
      direccion: json['direccion'] as String,
    );
  }
}
