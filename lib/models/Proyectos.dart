class Proyectos {
  String id_proyecto;
  String descripcion_proyecto;

  Proyectos({this.id_proyecto, this.descripcion_proyecto});

  factory Proyectos.fromJson(Map<String, dynamic> json) {
    return Proyectos(
      id_proyecto: (json['id_proyecto']) as String,
      descripcion_proyecto: json['descripcion_proyecto'] as String,
    );
  }

}