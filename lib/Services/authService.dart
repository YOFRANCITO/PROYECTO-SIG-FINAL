import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static late String _login;
  static late String _password;

  Future<bool> login(String login, String password) async {
    final url = Uri.parse('http://190.171.244.211:8080/wsVarios/wsAd.asmx');

    // Guardar las credenciales globales en variables estáticas
    _login = login;
    _password = password;

    // Cuerpo de la solicitud SOAP
    final soapBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ValidarLoginPassword xmlns="http://tempuri.org/">
      <lsLogin>$login</lsLogin>
      <lsPassword>$password</lsPassword>
    </ValidarLoginPassword>
  </soap:Body>
</soap:Envelope>
''';

    // Encabezados (ajustados según la configuración de Postman)
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '"http://tempuri.org/ValidarLoginPassword"',
    };

    try {
      // Envío de la solicitud POST
      final response = await http.post(
        url,
        headers: headers,
        body: soapBody,
      );

      // Mostrar el estado y la respuesta para depuración
      print("Estado de la solicitud: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        // Usar expresión regular para extraer el contenido de ValidarLoginPasswordResult
        final regExp = RegExp(r'<ValidarLoginPasswordResult>(.*?)</ValidarLoginPasswordResult>');
        final match = regExp.firstMatch(response.body);

        if (match != null) {
          final result = match.group(1);
          print('Resultado del login: $result');

          // Verificar si el resultado contiene el valor esperado
          if (result != null && result.startsWith('OK')) {
            // Guardar datos del usuario en la caché (SharedPreferences)
            await saveUserData({
              'token': 'sampleToken',
              'refreshToken': 'sampleRefreshToken',
              'expirationTime': '2025-01-01',
              'role': 'admin',
              'name': 'Cortes',
              'login': login, // Guardamos el login
              'password': password, // Guardamos la password
              'id': 12345,
            });

            // Verificar si los datos se guardaron en la caché
            await _verifyCache();

            return true; // Login exitoso
          }
        }

        return false; // Credenciales incorrectas o error en el formato
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción durante el login: $e');
      return false;
    }
  }

  // Método para guardar las credenciales en la caché (SharedPreferences)
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Imprimir los valores de login y password antes de guardarlos
    print("Guardando Login: ${_login}");
    print("Guardando Password: ${_password}");

    await prefs.setString('token', userData['token']);
    await prefs.setString('refreshToken', userData['refreshToken']);
    await prefs.setString('expirationTime', userData['expirationTime']);
    await prefs.setString('role', userData['role']);
    await prefs.setString('name', userData['name']);
    await prefs.setString('login', _login); // Guardar el login
    await prefs.setString('password', _password); // Guardar la password
    await prefs.setInt('id', userData['id']);
  }

  // Método para verificar si los datos se guardaron en la caché correctamente
  Future<void> _verifyCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login = prefs.getString('login');
    String? password = prefs.getString('password');

    // Imprimir los valores recuperados de la caché
    print("Login guardado: $login");
    print("Password guardada: $password");

    // Mostrar si los datos están en caché
    if (login != null && password != null) {
      print("Los datos están guardados correctamente.");
    } else {
      print("No se encontraron los datos en la caché.");
    }
  }

  // Método para obtener los datos del usuario
  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? refreshToken = prefs.getString('refreshToken');
    String? expirationTime = prefs.getString('expirationTime');
    String? role = prefs.getString('role');
    String? name = prefs.getString('name');
    String? login = prefs.getString('login');
    int? id = prefs.getInt('id');

    if (token != null && refreshToken != null && expirationTime != null && role != null) {
      return {
        'token': token,
        'refreshToken': refreshToken,
        'expirationTime': expirationTime,
        'role': role,
        'name': name,
        'login': login,
        'id': id,
      };
    } else {
      return null;
    }
  }

  // Método para limpiar los datos de usuario
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Método para comprobar si el usuario está logueado
  Future<bool> checkIfLoggedIn() async {
    Map<String, dynamic>? userData = await getUserData();
    return userData != null;
  }
}
