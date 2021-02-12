class Productos {
  String id_inventario;
  String id_producto;
  String codigo_cliente;
  String nombre_producto;
  String cantidad;
  String id_proyecto;

  Productos({this.id_inventario, this.id_producto,this.codigo_cliente,this.nombre_producto,this.cantidad,this.id_proyecto});

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      id_inventario: (json['id_inventario']) as String,
      id_producto: json['id_producto'] as String,
      codigo_cliente: json['codigo_cliente'] as String,
      nombre_producto: json['nombre_producto'] as String,
      cantidad: json['cantidad'] as String,
      id_proyecto: json['id_proyecto'] as String,
    );
  }
}