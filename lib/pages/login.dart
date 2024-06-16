import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../Services/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Por favor complete todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(email, password);
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Navegar a la pantalla de perfil si el login es exitoso
        Navigator.pushNamed(context, '/perfil');
      } else {
        _showSnackbar('Login fallido: ${response.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar('Login fallido: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade800,
                Colors.lightBlue.shade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInDown(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Bienvenido",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInDown(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Por favor, inicia sesión",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FadeInDown(
                        duration: Duration(milliseconds: 1400),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInDown(
                        duration: Duration(milliseconds: 1500),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInDown(
                        duration: Duration(milliseconds: 1600),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInDown(
                        duration: Duration(milliseconds: 1700),
                        child: MaterialButton(
                          onPressed: _isLoading ? null : _login,
                          height: 50,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Iniciar Sesión",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Reduce el espacio aquí
            ],
          ),
        ),
      ),
    );
  }
}
