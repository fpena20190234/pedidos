class Idp_actividades_mt{
  String id_idp_actividades_mt;
  String id_idp_actividades;
  String id_idp;
  String codigo_recurso;
  String cantidad;
  String valor_unitario;
  String valor_total;

  Idp_actividades_mt({
    this.id_idp_actividades_mt,
    this.id_idp_actividades,
    this.id_idp,
    this.codigo_recurso,
    this.cantidad,
    this.valor_unitario,
    this.valor_total
  });

  factory Idp_actividades_mt.fromJson(Map<String, dynamic> json) {
    return Idp_actividades_mt(
      id_idp_actividades_mt: (json['id_idp']) as String,
      id_idp_actividades: json['numero_idp'] as String,
      id_idp: json['fecha'] as String,
      codigo_recurso: json['supervisor_deltec'] as String,
      cantidad: json['supervisor_edeeste'] as String,
      valor_unitario: json['observaciones_idp'] as String,
      valor_total: json['proyecto'] as String,
      );
  }

}