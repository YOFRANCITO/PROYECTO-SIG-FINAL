import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';
import '../services/asistenciaService.dart';
import '../services/grupohoraService.dart';
import '../models/grupohora.dart';
import 'soliPermiso.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MarcarAsist extends StatefulWidget {
  const MarcarAsist({Key? key}) : super(key: key);

  @override
  _MarcarAsistState createState() => _MarcarAsistState();
}


class _MarcarAsistState extends State<MarcarAsist> {
  bool _isButtonEnabled = true;

  static double latitud = 0.0;
  static double longitud = 0.0;
  late Future<List<Grupo2>> futureGrupos;
  int? _selectedGrupoId;

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
      longitud = position.longitude;
      latitud = position.latitude;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Earth's radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  void sendAttendance({required bool isVirtual}) async {
    double latitudeToSend = isVirtual ? 1.0 : latitud;
    double longitudeToSend = isVirtual ? 1.0 : longitud;

    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm:ss').format(now);
    final currentDay = DateFormat('EEEE', 'es_ES').format(now);

    final selectedGrupo = (await futureGrupos)
        .firstWhere((grupo) => grupo.id == _selectedGrupoId);

    // Validate time
    final startTime = selectedGrupo.horarios.first.horainicio;
    final endTime = selectedGrupo.horarios.first.horafin;
    final isWithinTimeRange = currentTime.compareTo(startTime) >= 0 &&
        currentTime.compareTo(endTime) <= 0;

    // Obtener la hora de inicio del grupo y agregar la fecha actual
    final startTimeString =
        '${DateFormat('yyyy-MM-dd').format(now)} ${selectedGrupo.horarios.first.horainicio}';

    // Convertir la cadena a un objeto DateTime
    final startTime2 = DateTime.parse(startTimeString);
    // Calcular la diferencia de tiempo en minutos
    final difference = now.difference(startTime2).inMinutes;
    // Establecer la descripción basada en la diferencia de tiempo
    String description;
    if (difference <= 10) {
      description = "Presente";
    } else if (difference > 10 && difference <= 30) {
      description = "Atraso";
    } else {
      description = "Falta";
    }

    // Validate day
    final dayFromDb = selectedGrupo.horarios.first.dia;
    final isCorrectDay = currentDay.toLowerCase() == dayFromDb.toLowerCase();

    // Validate location
    bool isWithinLocationRange;
    if (isVirtual) {
      isWithinLocationRange = true;
      description = "virtual";
    } else {
      final distance = calculateDistance(
        latitudeToSend,
        longitudeToSend,
        selectedGrupo.horarios.first.moduloLatitud,
        selectedGrupo.horarios.first.moduloLongitud,
      );

      isWithinLocationRange = distance <= 50.0; // 50 meters range
    }

    String tiempo2 =
        '${(difference ~/ 60).toString().padLeft(2, '0')}:${(difference % 60).toString().padLeft(2, '0')}:00';

    if (isWithinTimeRange) {
      if (isCorrectDay) {
        if (isWithinLocationRange) {
          final asistencia = Asistencia(
            id: 0,
            descripcion: description,
            hora: DateFormat('HH:mm:ss').format(now),
            fecha: now,
            tiempo: tiempo2,
            estado: "activo",
            latitud: latitudeToSend,
            longitud: longitudeToSend,
            grupo: Grupo(id: _selectedGrupoId!),
          );

          final response =
              await MarcarAsistService().marcarAsistencia(asistencia);

          if (response.containsKey('error')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error al marcar asistencia: ${response['error']}'),
              ),
            );
          } else {
            setState(() {
              _isButtonEnabled = false; // Disable the button
            });
            _timer = Timer(Duration(minutes: 1), () {
              setState(() {
                _isButtonEnabled = true; // Enable the button again
              });
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Asistencia marcada con éxito'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('No está dentro del rango de ubicación permitido.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No es el día permitido.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No está dentro del rango de tiempo permitido.'),
        ),
      );
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    futureGrupos = GrupoService().fetchGrupos();
    _selectedGrupoId = null; // Inicializa como null para no tener valor seleccionado al inicio
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
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FutureBuilder<List<Grupo2>>(
                          future: futureGrupos,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData) {
                              return Center(child: Text('No hay datos'));
                            } else {
                              List<Grupo2> grupos = snapshot.data!;
                              return DropdownButton<int>(
                                value: _selectedGrupoId,
                                hint: Text('Selecciona un grupo'),
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.blue.shade900),
                                underline: SizedBox(),
                                items: grupos.map((grupo) {
                                  return DropdownMenuItem<int>(
                                    value: grupo.id,
                                    child: Text(
                                      'Aula: ${grupo.horarios.first.aulaNombre} | Grupo: ${grupo.nombre} | Materia: ${grupo.materiaNombre} | ${grupo.horarios.first.dia}- ${grupo.horarios.isNotEmpty ? "${grupo.horarios.first.horainicio} - ${grupo.horarios.first.horafin}" : "Horario no disponible"}',
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGrupoId = value;
                                  });
                                  print('Grupo seleccionado: $_selectedGrupoId');
                                },
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Posición: $latitud, $longitud",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                sendAttendance(isVirtual: false);
                              }
                            : null,
                        height: 50,
                        color: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Marcar Asistencia",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SolicitarPermisoPage()),
                                );
                              },
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.black,
                              child: Center(
                                child: Text(
                                  "Solicitar Licencia",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
