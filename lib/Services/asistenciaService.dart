import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/apiBack.dart';

class Asistencia {
  int? id; // Cambia a int? para hacerlo opcional
  String descripcion;
  String hora;
  DateTime fecha;
  String tiempo;
  String estado;
  double latitud;
  double longitud;
  Grupo grupo;

  Asistencia({
    this.id, // Elimina el required
    required this.descripcion,
    required this.hora,
    required this.fecha,
    required this.tiempo,
    required this.estado,
    required this.latitud,
    required this.longitud,
    required this.grupo,
  });

  Map toJson() {
    return {
      'descripcion': descripcion,
      'hora': hora,
      'fecha': fecha.toIso8601String().split('T').first,
      'tiempo': tiempo,
      'estado': estado,
      'latitud': latitud,
      'longitud': longitud,
      'grupo': {'id': grupo.id},
    };
  }
}

class Grupo {
  int id;

  Grupo({
    required this.id,
  });
}

class MarcarAsistService {
  final String apiUrl = "$apiBack/asistencias";

  Future<Map<String, dynamic>> marcarAsistencia(Asistencia asistencia) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return {'error': 'Token no encontrado'};
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(asistencia.toJson()),
    );

    if (response.statusCode == 200) {
      print("Respuesta Marc Asist: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("Respuesta Error: ${response.body}");
      return {'error': 'Error en la solicitud: ${response.statusCode}'};
    }
  }
}
