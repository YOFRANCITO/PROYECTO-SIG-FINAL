// models.dart
import 'dart:convert';

class Facultad {
  final int id;
  final String codigo;
  final String nombre;

  Facultad({required this.id, required this.codigo, required this.nombre});

  factory Facultad.fromJson(Map<String, dynamic> json) {
    return Facultad(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
    );
  }
}

class Carrera {
  final int id;
  final String nro;
  final String nombre;
  final Facultad facultad;

  Carrera({required this.id, required this.nro, required this.nombre, required this.facultad});

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'],
      nro: json['nro'],
      nombre: json['nombre'],
      facultad: Facultad.fromJson(json['facultad']),
    );
  }
}

class Gestion {
  final int id;
  final String nombre;

  Gestion({required this.id, required this.nombre});

  factory Gestion.fromJson(Map<String, dynamic> json) {
    return Gestion(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class Materia {
  final int id;
  final String nombre;
  final String sigla;

  Materia({required this.id, required this.nombre, required this.sigla});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nombre: json['nombre'],
      sigla: json['sigla'],
    );
  }
}

class Authority {
  final String authority;

  Authority({required this.authority});

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      authority: json['authority'],
    );
  }
}

class OurUser {
  final int id;
  final String email;
  final String name;
  final String password;
  final String role;
  final bool enabled;
  final List<Authority> authorities;
  final String username;
  final bool accountNonLocked;
  final bool accountNonExpired;
  final bool credentialsNonExpired;

  OurUser({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
    required this.enabled,
    required this.authorities,
    required this.username,
    required this.accountNonLocked,
    required this.accountNonExpired,
    required this.credentialsNonExpired,
  });

  factory OurUser.fromJson(Map<String, dynamic> json) {
    var list = json['authorities'] as List;
    List<Authority> authoritiesList = list.map((i) => Authority.fromJson(i)).toList();

    return OurUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      role: json['role'],
      enabled: json['enabled'],
      authorities: authoritiesList,
      username: json['username'],
      accountNonLocked: json['accountNonLocked'],
      accountNonExpired: json['accountNonExpired'],
      credentialsNonExpired: json['credentialsNonExpired'],
    );
  }
}

class SistemaAcademico {
  final int id;
  final String nombre;

  SistemaAcademico({required this.id, required this.nombre});

  factory SistemaAcademico.fromJson(Map<String, dynamic> json) {
    return SistemaAcademico(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class Grupo {
  final int id;
  final String nombre;
  final int cupo;
  final Carrera carrera;
  final Gestion gestion;
  final Materia materia;
  final OurUser ourUser;
  final SistemaAcademico sistemaAcademico;

  Grupo({
    required this.id,
    required this.nombre,
    required this.cupo,
    required this.carrera,
    required this.gestion,
    required this.materia,
    required this.ourUser,
    required this.sistemaAcademico,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      nombre: json['nombre'],
      cupo: json['cupo'],
      carrera: Carrera.fromJson(json['carrera']),
      gestion: Gestion.fromJson(json['gestion']),
      materia: Materia.fromJson(json['materia']),
      ourUser: OurUser.fromJson(json['ourUsers']),
      sistemaAcademico: SistemaAcademico.fromJson(json['sistemaacademico']),
    );
  }
}
