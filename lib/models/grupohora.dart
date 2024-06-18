class Grupo2 {
  final int id;
  final String nombre;
  final int cupo;
  final String carreraNombre;
  final String gestionNombre;
  final String materiaNombre;
  final String ourUsersNombre;
  final String sistemaacademicoNombre;
  final List<Horario> horarios;

  Grupo2({
    required this.id,
    required this.nombre,
    required this.cupo,
    required this.carreraNombre,
    required this.gestionNombre,
    required this.materiaNombre,
    required this.ourUsersNombre,
    required this.sistemaacademicoNombre,
    required this.horarios,
  });

  factory Grupo2.fromJson(Map<String, dynamic> json) {
    var list = json['horarios'] as List;
    List<Horario> horariosList = list.map((i) => Horario.fromJson(i)).toList();

    return Grupo2(
      id: json['id'],
      nombre: json['nombre'],
      cupo: json['cupo'],
      carreraNombre: json['carreraNombre'],
      gestionNombre: json['gestionNombre'],
      materiaNombre: json['materiaNombre'],
      ourUsersNombre: json['ourUsersNombre'],
      sistemaacademicoNombre: json['sistemaacademicoNombre'],
      horarios: horariosList,
    );
  }
}

class Horario {
  final String dia;
  final String horainicio;
  final String horafin;
  final String aulaNombre;
  final double moduloLatitud;
  final double moduloLongitud;

  Horario({
    required this.dia,
    required this.horainicio,
    required this.horafin,
    required this.aulaNombre,
    required this.moduloLatitud,
    required this.moduloLongitud,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      dia: json['dia'],
      horainicio: json['horainicio'],
      horafin: json['horafin'],
      aulaNombre: json['aulaNombre'],
      moduloLatitud: json['moduloLatitud'],
      moduloLongitud: json['moduloLongitud'],
    );
  }
}
