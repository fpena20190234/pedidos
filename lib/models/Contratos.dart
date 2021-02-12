class Contratos {
  String id_empresa;
  String nombre_empresa;
  String telefono;

  Contratos({this.id_empresa, this.nombre_empresa, this.telefono});

  factory Contratos.fromJson(Map<String, dynamic> json) {
    return Contratos(
      id_empresa: (json['id_empresa']) as String,
      nombre_empresa: json['nombre_empresa'] as String,
      telefono: json['telefono'] as String,
    );
  }
}
