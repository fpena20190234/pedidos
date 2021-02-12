class Idp {
  String id_idp;
  String numero_idp;
  String fecha;
  String supervisor_deltec;
  String supervisor_edeeste;
  String observaciones_idp;
  String proyecto;
  String estado_idp;
  String vehiculo;
  String fecha_fin;
  String ciudad;
  String id_empresa;
  String fecha_inicio;
  String observacion_brigada;
  String liniero;
  String fecha_visita;
  String idp_edeeste;
  String total;
  String total_recurso;
  String motivo;

  Idp({
        this.id_idp,
        this.numero_idp,
        this.fecha,
        this.supervisor_deltec,
        this.supervisor_edeeste,
        this.observaciones_idp,
        this.proyecto,
        this.estado_idp,
        this.vehiculo,
        this.fecha_fin,
        this.ciudad,
        this.id_empresa,
        this.fecha_inicio,
        this.observacion_brigada,
        this.liniero,
        this.fecha_visita,
        this.idp_edeeste,
        this.total,
        this.total_recurso,
        this.motivo
  });

  factory Idp.fromJson(Map<String, dynamic> json) {
    return Idp(
      id_idp: json['id_idp'] as String,
      numero_idp: json['numero_idp'] as String,
      fecha: json['fecha'] as String,
      supervisor_deltec: json['supervisor_deltec'] as String,
      supervisor_edeeste: json['supervisor_edeeste'] as String,
      observaciones_idp: json['observaciones_idp'] as String,
      proyecto: json['proyecto'] as String,
      estado_idp: json['estado_idp'] as String,
      vehiculo: json['vehiculo'] as String,
      fecha_fin: json['fecha_fin'] as String,
      ciudad: json['ciudad'] as String,
      id_empresa: json['id_empresa'] as String,
      fecha_inicio: json['fecha_inicio'] as String,
      observacion_brigada: json['observacion_brigada'] as String,
      liniero: json['liniero'] as String,
      fecha_visita: json['fecha_visita'] as String,
      idp_edeeste: json['idp_edeeste'] as String,
      total: json['total'] as String,
      total_recurso: json['total_recurso'] as String,
      motivo: json['motivo'] as String,
    );
  }
}
