class Materiales {
  String codigo_cliente;
  String nombre_producto;
  String cantidad;

  Materiales({
    this.codigo_cliente,
    this.nombre_producto,
    this.cantidad
  });

  factory Materiales.fromJson(Map<String, dynamic> json) {
    return Materiales(
      codigo_cliente: (json['codigo_cliente']) as String,
      nombre_producto: json['nombre_producto'] as String,
      cantidad: json['cantidad'] as String,
    );
  }
}