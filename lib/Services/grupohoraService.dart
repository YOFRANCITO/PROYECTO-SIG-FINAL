import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grupohora.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/apiBack.dart';

class GrupoService {
   static const String apiUrl = "$apiBack/grupos/ourUsers";

  Future<List<Grupo2>> fetchGrupos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    String? token = prefs.getString('token');

    // Modificar la URL para incluir el ID en la ruta
    String urlWithId = '$apiUrl/$id/horarios';

    final response = await http.get(Uri.parse(urlWithId),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("Esta es la respuesta del back: ${response.body}");

    if (response.statusCode == 200) {
      // Corregir la conversión según la estructura de la respuesta
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((grupo) => Grupo2.fromJson(grupo)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        // Manejar el caso si la respuesta es un objeto JSON
        // Aquí puedes procesar el objeto directamente si es necesario
        return [Grupo2.fromJson(jsonResponse)];
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    } else {
      throw Exception('Failed to load grupos');
    }
  }
}
