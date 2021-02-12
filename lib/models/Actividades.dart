class Actividades {
  String codigo_cliente;
  String nombre_producto;
  String valor_producto;

  Actividades({
    this.codigo_cliente,
    this.nombre_producto,
    this.valor_producto
  });

  factory Actividades.fromJson(Map<String, dynamic> json) {
    return Actividades(
      codigo_cliente: (json['codigo_cliente']) as String,
      nombre_producto: json['nombre_producto'] as String,
      valor_producto: json['valor_producto'] as String,
    );
  }
}