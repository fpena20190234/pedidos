class Conductores {
  String id;
  String nombre_conductor;

  Conductores({this.id, this.nombre_conductor});

  factory Conductores.fromJson(Map<String, dynamic> json) {
    return Conductores(
      id: (json['id']) as String,
      nombre_conductor: json['nombre_usuario'] as String,
    );
  }
}