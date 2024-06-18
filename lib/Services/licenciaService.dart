//  import 'dart:convert';
//  import 'package:http/http.dart' as http;
//  import 'package:shared_preferences/shared_preferences.dart';

//  import '../utils/apiBack.dart';


//  class Licencia {
//    int? id;
//    String descripcion;
//    String hora;
//    DateTime fecha;
//    Grupo grupo;

//    Licencia({
//      this.id,
//      required this.descripcion,
//      required this.hora,
//      required this.fecha,
//      required this.grupo,
//    });


//    Map toJson() {
//      return {
//        'id': id,
//        'descripcion': descripcion,
//        'hora': hora,
//        'fecha': fecha.toIso8601String(),
//        'grupo': {'id': grupo.id},
//      };
//    }
//  }

//  class Grupo {
//    int id;

//    Grupo({
//      required this.id,
//    });

//  }


//  class RegistrarLicencia {
//    final String apiUrl = "$apiBack/licencias";

//    Future<Map<String, dynamic>> registrarLicencia(Licencia licencia) async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      String? token = prefs.getString('token');

//      if (token == null) {
//        return {'error': 'Token no encontrado'};
//      }

//      final response = await http.post(
//        Uri.parse(apiUrl),
//        headers: {
//          'Content-Type': 'application/json',
//          'Authorization': 'Bearer $token',
//        },
//        body: jsonEncode(licencia.toJson()),
//      );

//      if (response.statusCode == 200) {
//        print("Respuesta Marc Asist: ${response.body}");
//        return jsonDecode(response.body);
//      } else {
//        print("Respuesta Error: ${response.body}");
//        return {'error': 'Error en la solicitud: ${response.statusCode}'};
//      }
//    }
//  }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/apiBack.dart';

class Licencia2 {
  int? id;
  String descripcion;
  String hora;
  DateTime fecha;
  Grupo3 grupo;
  OurUser2 ourUser;
  
  Licencia2({
    this.id,
    required this.descripcion,
    required this.hora,
    required this.fecha,
    required this.grupo,
    required this.ourUser,  
  });

  Map toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'hora': hora,
      'fecha': fecha.toIso8601String(),
      'grupo': {'id': grupo.id},
      'ourUsers': {'id': ourUser.id},  
    };
  }
}




class OurUser2 {
   int id;
  

  OurUser2({
    required this.id,
    
  });

  
}

class Grupo3 {
  int id;

  Grupo3({
    required this.id,
  });
}


class RegistrarLicencia2 {
   final String apiUrl = "$apiBack/licencias";

   Future<Map<String, dynamic>> registrarLicencia(Licencia2 licencia) async {
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
       body: jsonEncode(licencia.toJson()),
     );

     if (response.statusCode == 200 || response.statusCode == 201) {
       print("Respuesta Marc Asist: ${response.body}");
       return jsonDecode(response.body);
     } else {
       print("Respuesta Error: ${response.body}");
       return {'error': 'Error en la solicitud: ${response.statusCode}'};
     }
   }
 }