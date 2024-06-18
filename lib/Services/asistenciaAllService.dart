import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movil_system_si2/utils/apiBack.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsistenciaModel {
  final int id;
  final String descripcion;
  final String hora;
  final String fecha;
  final String tiempo;
  final String estado;
  final double latitud;
  final double longitud;

  AsistenciaModel({
    required this.id,
    required this.descripcion,
    required this.hora,
    required this.fecha,
    required this.tiempo,
    required this.estado,
    required this.latitud,
    required this.longitud,
  });

  factory AsistenciaModel.fromJson(Map<String, dynamic> json) {
    return AsistenciaModel(
      id: json['id'],
      descripcion: json['descripcion'],
      hora: json['hora'],
      fecha: json['fecha'],
      tiempo: json['tiempo'],
      estado: json['estado'],
      latitud: json['latitud'],
      longitud: json['longitud'],
    );
  }
}




class AsistenciaService2 {
  static const String apiUrl = "$apiBack/asistencias";

  Future<List<AsistenciaModel>> fetchGrupos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   
    String? token = prefs.getString('token');

    // Modificar la URL para incluir el ID en la ruta

    final response = await http.get(Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("Esta es la respuesta del back: ${response.body}");

    if (response.statusCode == 200) {
      // Corregir la conversión según la estructura de la respuesta
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((grupo) => AsistenciaModel.fromJson(grupo)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        // Manejar el caso si la respuesta es un objeto JSON
        // Aquí puedes procesar el objeto directamente si es necesario
        return [AsistenciaModel.fromJson(jsonResponse)];
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    } else {
      throw Exception('Failed to load grupos');
    }
  }

}

