import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import '../utils/apiBack.dart';
import '../models/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$apiBackC/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print("Respuesta del login: ${response.body}");
      final userData = json.decode(response.body);
      await saveUserData(userData);
      return LoginResponse.fromJson(userData);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userData['token']);
    await prefs.setString('refreshToken', userData['refreshToken']);
    await prefs.setString('expirationTime', userData['expirationTime']);
    await prefs.setString('role', userData['role']);
        await prefs.setString('name', userData['name']);

    await prefs.setInt('id', userData['id']);

  }
}

Future<Map<String, dynamic>?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? refreshToken = prefs.getString('refreshToken');
  String? expirationTime = prefs.getString('expirationTime');
  String? role = prefs.getString('role');
    String? name = prefs.getString('name');

  int? id = prefs.getInt('id');

  if (token != null && refreshToken != null && expirationTime != null && role != null) {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expirationTime': expirationTime,
      'role': role,
      'name': role,
      'id': id,
    };
  } else {
    return null;
  }
}

Future<void> clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<bool> checkIfLoggedIn() async {
  Map<String, dynamic>? userData = await getUserData();
  return userData != null;
}
