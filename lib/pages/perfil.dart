// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late String _name='';
  late String _role='';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario desde las preferencias compartidas
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'Nombre Desconocido';
      _role = prefs.getString('role') ?? 'Rol Desconocido';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Mi Perfil'), // Integrar el drawer aquí
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade800,
                Colors.lightBlue.shade400
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInDown(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Perfil del Usuario",
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInDown(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Información personal",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40), // Espacio para la imagen de perfil
                        FadeInDown(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            _name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        FadeInDown(
                          duration: Duration(milliseconds: 1600),
                          child: Text(
                            _role,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        FadeInDown(
                          duration: Duration(milliseconds: 1700),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.code, color: Colors.blue.shade900),
                                  title: Text(
                                    "Código de docente: 123",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.badge, color: Colors.blue.shade900),
                                  title: Text(
                                    "CI: 1414258",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.phone, color: Colors.blue.shade900),
                                  title: Text(
                                    "+1 234 567 890",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.home, color: Colors.blue.shade900),
                                  title: Text(
                                    "los lotes",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: FadeInDown(
                      duration: Duration(milliseconds: 1400),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white, // Borde blanco grueso
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Reemplazar con imagen real
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}
