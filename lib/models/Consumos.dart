class Consumos {
  String id;
  String estacion;
  String vehiculo;
  String fecha;
  String km;
  String galones;
  String valor;
  String idempresa;
  String idusuario;

  Consumos({this.id, this.estacion,this.vehiculo,this.fecha,this.km,this.galones,this.valor,this.idempresa,this.idusuario});

  factory Consumos.fromJson(Map<String, dynamic> json) {
    return Consumos(
      id: (json['id_combustible']) as String,
      estacion: json['nombre_estacion'] as String,
      vehiculo: json['alias'] as String,
      fecha: json['fecha_tanqueo'] as String,
      km: json['kilometraje_actual'] as String,
      galones: json['cantidad'] as String,
      valor: json['valor_carga'] as String,
      idusuario: json['usuario_creacion'] as String,
    );
  }
}