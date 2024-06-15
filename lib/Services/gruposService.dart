// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movil_system_si2/utils/apiBack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/GrupoModel.dart';

class ApiService {
  static const String apiUrl = "$apiBack/grupos";

  Future<List<Grupo>> fetchGrupos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(Uri.parse(apiUrl),
          headers: {
        'Authorization': 'Bearer $token',
      },
    );
print("Esta es la respuesta del back: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((grupo) => Grupo.fromJson(grupo)).toList();
    } else {
      throw Exception('Failed to load grupos');
    }
  }
}
