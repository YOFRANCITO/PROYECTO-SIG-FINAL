import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../Services/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    final login = _loginController.text;
    final password = _passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      _showSnackbar('Por favor complete todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bool isSuccess = await _authService.login(login, password);

      setState(() {
        _isLoading = false;
      });

      if (isSuccess) {
        Navigator.pushNamed(context, '/perfil');
      } else {
        _showSnackbar('Credenciales inválidas');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar('Error al iniciar sesión: $e');
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
              SizedBox(height: 80), // Reduce el espacio aquí para mover el logo más arriba

              // Logo de la aplicación
              FadeInDown(
                duration: Duration(milliseconds: 800),
                child: Image.asset(
                  'assets/images/logo.png', // Reemplaza con la ruta de tu logo
                  width: 150, // Ajusta el tamaño según lo necesites
                  height: 150,
                ),
              ),

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
              SizedBox(height: 20),
              Expanded(
                child: Container(
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
                            controller: _loginController,
                            decoration: InputDecoration(
                              labelText: "Usuario",
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
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
