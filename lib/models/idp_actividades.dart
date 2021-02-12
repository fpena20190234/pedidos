class Idp_actividades {
  String id_idp_actividad;
  String codigo_actividad;
  String cantidad;
  String direccion;
  String poste;
  String observaciones_idp_actividad;
  String id_idp;
  String factor_k;
  String valor_unitario;
  String valor_total;
  String id_actividad;
  String fecha_actividad;

  Idp_actividades({
    this.id_idp_actividad,
    this.codigo_actividad,
    this.cantidad,
    this.direccion,
    this.poste,
    this.observaciones_idp_actividad,
    this.id_idp,
    this.factor_k,
    this.valor_unitario,
    this.valor_total,
    this.id_actividad,
    this.fecha_actividad
  });

  factory Idp_actividades.fromJson(Map<String, dynamic> json) {
    return Idp_actividades(
      id_idp_actividad: (json['id_idp']) as String,
      codigo_actividad: json['numero_idp'] as String,
      cantidad: json['fecha'] as String,
      direccion: json['supervisor_deltec'] as String,
      poste: json['supervisor_edeeste'] as String,
      observaciones_idp_actividad: json['observaciones_idp'] as String,
      id_idp: json['proyecto'] as String,
      factor_k: json['estado_idp'] as String,
      valor_unitario: json['vehiculo'] as String,
      valor_total: json['fecha_fin'] as String,
      id_actividad: json['ciudad'] as String,
      fecha_actividad: json['id_empresa'] as String,
    );
  }
}

