class Idp_recursos {
  String id_foto;
  String nombre_foto;
  String comentario_foto;
  String id_trabajo;

  Idp_recursos({
    this.id_foto,
    this.nombre_foto,
    this.comentario_foto,
    this.id_trabajo,
  });

  factory Idp_recursos.fromJson(Map<String, dynamic> json) {
    return Idp_recursos(
      id_foto: (json['id_foto']) as String,
      nombre_foto: json['nombre_foto'] as String,
      comentario_foto: json['comentario_foto'] as String,
      id_trabajo: json['id_trabajo'] as String
    );
  }
}