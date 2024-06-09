// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '/pages/soliPermiso.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class MarcarAsist extends StatefulWidget {
  const MarcarAsist({super.key});

  @override
  _MarcarAsistState createState() => _MarcarAsistState();
}

class _MarcarAsistState extends State<MarcarAsist> {
  static String latitud = "";
  static String longitud = "";
  String selectedSubject = "Matemáticas"; // Valor inicial de la lista desplegable

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      longitud = position.longitude.toString();
      latitud = position.latitude.toString();
    });
  }

  void sendAttendance({required bool isVirtual}) {
    // Aquí se debería enviar la asistencia al backend
    String latitudeToSend = isVirtual ? "null" : latitud;
    String longitudeToSend = isVirtual ? "null" : longitud;

    // Simulación de envío
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Asistencia marcada: Materia: $selectedSubject, Latitud: $latitudeToSend, Longitud: $longitudeToSend',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Stream<String> getCurrentTime() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateFormat('HH:mm:ss').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Marcar Asistencia'),
      body: Container(
        width: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Marcar Asistencia",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<String>(
                  stream: getCurrentTime(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "Hora actual: ${snapshot.data}",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      );
                    } else {
                      return Text(
                        "Hora actual: Cargando...",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Ingrese su Código de docente",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: selectedSubject,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSubject = newValue!;
                            });
                          },
                          items: <String>['Matemáticas', 'Ciencias', 'Historia']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Posición: $latitud, $longitud",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          sendAttendance(isVirtual: false);
                        },
                        height: 50,
                        color: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Marcar Asistencia",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Solicite permisos especiales",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                sendAttendance(isVirtual: true);
                              },
                              height: 50,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Clases virtuales",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SolicitarPermisoPage()),
                                );
                              },
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.black,
                              child: Center(
                                child: Text(
                                  "Permiso de inasistencia",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }
}

class Materia {
  final String nombre;
  final String sigla;
  final String grupo;
  final String horario;
  final String aula;
  final int startHour;
  final int endHour;

  Materia(this.nombre, this.sigla, this.grupo, this.horario, this.aula, this.startHour, this.endHour);
}
