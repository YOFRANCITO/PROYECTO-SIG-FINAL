import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:movil_system_si2/pages/MenuCortespages/registrarcortes.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class RutasMapa extends StatefulWidget {
  @override
  _RutasMapaState createState() => _RutasMapaState();
}

class _RutasMapaState extends State<RutasMapa> {
  late Database _database;
  late GoogleMapController _mapController;
  final TextEditingController _codigoFijoController = TextEditingController();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> _resultados = [];

  final String _apiKey =
      'AIzaSyDglqfPCCLl7q-4lL7WL3yNyJxKG-RNK2Y'; // Reemplaza con tu API Key

  final LatLng _puntoInicial =
      LatLng(-16.379689, -60.960748); // Punto inicial fijo

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    // Abre la base de datos existente sin crear una nueva
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'base2.db'),
      version: 1,
    );
  }

  // Función para convertir valores de latitud y longitud a double
  double _convertToDouble(dynamic value) {
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<BitmapDescriptor> _crearIconoPersonalizado(
      String texto, Color color) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;

    // Dibuja un círculo
    const double radio = 40.0;
    canvas.drawCircle(Offset(radio, radio), radio, paint);

    // Dibuja el texto del número
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: texto,
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(radio - textPainter.width / 2, radio - textPainter.height / 2));

    final img = await pictureRecorder
        .endRecording()
        .toImage(radio.toInt() * 2, radio.toInt() * 2);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

// Variable globales para almacenar la distancia y el tiempo total
  double _distanciaTotal = 0.0; // Distancia total en metros
  Duration _tiempoTotal = Duration(seconds: 0); // Tiempo total en segundos

// Función para obtener la ruta y duración desde Google Directions API
  Future<void> _getRutaDeGoogle(
      double lat1, double lon1, double lat2, double lon2, String rutaId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$lat1,$lon1&destination=$lat2,$lon2&key=$_apiKey&mode=driving',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'];

      if (routes.isNotEmpty) {
        final overviewPolyline = routes[0]['overview_polyline']['points'];
        final decodedPoints = _decodificarPolyline(overviewPolyline);

        // Obtener distancia y tiempo de cada tramo
        final leg = routes[0]['legs'][0];
        final distance = leg['distance']['value']; // Distancia en metros
        final duration = leg['duration']['value']; // Duración en segundos

        // Actualizar la distancia y el tiempo total
        setState(() {
          _distanciaTotal += distance;
          _tiempoTotal += Duration(seconds: duration);
        });

        // Añadir la polilínea al mapa
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('ruta_${lat1}to${lat2}'),
            points: decodedPoints,
            color: Colors.blue,
            width: 5,
          ));
        });

        // Obtener el estado del punto para definir el color del icono
        var ruta = _resultados
            .firstWhere((r) => r['latitud'] == lat2 && r['longitud'] == lon2);
        String estado = ruta['estado']; // Obtener estado

        // Definir el color basado en el estado
        Color color;
        switch (estado) {
          case 'N/A':
            color = Colors.red;
            break;
          case 'Observacion':
            color = Colors.orange;
            break;
          case 'Ninguno':
            color = Colors.green;
            break;
          default:
            color = Colors.grey; // Color predeterminado
        }

        // Crear el ícono personalizado
        final icono = await _crearIconoPersonalizado(rutaId, color);

        // Añadir marcador con el ícono personalizado
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(rutaId),
            position: LatLng(lat2, lon2),
            infoWindow: InfoWindow(
              title: 'Punto $rutaId Duración: ${leg['duration']['text']}',
            ),
            icon: icono, // Usar el icono personalizado
            onTap: () {
              var ruta = _resultados.firstWhere(
                  (r) => r['latitud'] == lat2 && r['longitud'] == lon2);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registrarcortes(
                    nombre: ruta['nombre'],
                    codUbicacion: ruta['cu'],
                    codFijo: ruta['cf'],
                    medidorSerie: ruta['medidor_serie'],
                    idCorte: ruta['id'],
                  ),
                ),
              ).then((_) {
                // Después de regresar de la pantalla de `Registrarcortes`, recargamos las rutas
                _buscarRutasPorCodigo(); // Llamamos a esta función para recargar los puntos
              });
            },
          ));
        });
      } else {
        print('No se encontraron rutas.');
      }
    } else {
      print('Error al obtener la ruta: ${response.statusCode}');
    }
  }

// Función para calcular el tiempo total
  String _calcularTiempoTotal() {
    // Calculamos el tiempo de tránsito con una velocidad de 15 km/h
    double velocidad = 15.0; // Velocidad en km/h
    double distanciaEnKm =
        _distanciaTotal / 1000.0; // Convertimos la distancia a km
    double tiempoDeTransitoEnHoras =
        distanciaEnKm / velocidad; // Tiempo en horas
    int tiempoDeTransitoEnSegundos =
        (tiempoDeTransitoEnHoras * 3600).toInt(); // Tiempo en segundos

    // Inicializamos el tiempo de cortes en segundos
    int tiempoDeCortesEnSegundos = 0;

    // Iteramos sobre los resultados y sumamos los 10 minutos solo si el estado no es "Ninguno"
    for (var ruta in _resultados) {
      String estado = ruta['estado']; // Obtener estado del punto
      if (estado != 'Ninguno') {
        tiempoDeCortesEnSegundos +=
            10 * 60; // Sumamos 10 minutos (600 segundos) por cada corte
      }
    }

    // Sumar el tiempo de tránsito y el tiempo de cortes
    _tiempoTotal = Duration(
        seconds: tiempoDeTransitoEnSegundos + tiempoDeCortesEnSegundos);

    // Convertimos el tiempo total a formato HH:MM:SS
    int horas = _tiempoTotal.inHours;
    int minutos = _tiempoTotal.inMinutes % 60;
    int segundos = _tiempoTotal.inSeconds % 60;

    return '$horas:${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

// Función para calcular la distancia total en km
  String _calcularDistanciaTotal() {
    double distanciaEnKm =
        _distanciaTotal / 1000.0; // Convertimos la distancia a km
    return '${distanciaEnKm.toStringAsFixed(2)} km'; // Devolvemos la distancia con dos decimales
  }

  // Función para decodificar la polilínea de Google Directions
  List<LatLng> _decodificarPolyline(String polyline) {
    List<LatLng> puntos = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, resultado = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        resultado |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((resultado & 1) != 0 ? ~(resultado >> 1) : (resultado >> 1));
      lat += dLat;

      shift = 0;
      resultado = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        resultado |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((resultado & 1) != 0 ? ~(resultado >> 1) : (resultado >> 1));
      lng += dLng;

      puntos.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return puntos;
  }

  // Función que obtiene las rutas de la base de datos y marca los puntos en el mapa
  Future<void> _buscarRutasPorCodigo() async {
    setState(() {
      // Resetear distancia y tiempo total antes de recargar las rutas
      _distanciaTotal = 0.0;
      _tiempoTotal = const Duration(seconds: 0);
      _markers.clear();
      _polylines.clear();
    });

    final codigoBuscado = _codigoFijoController.text.trim();
    if (codigoBuscado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingrese un código de ruta.")),
      );
      return;
    }

    try {
      // Consulta en la base de datos usando el código de ruta
      final resultados = await _database.query(
        'rutast',
        where: 'nro_ruta = ?',
        whereArgs: [codigoBuscado],
      );

      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se encontraron rutas para este código.")),
        );
        return;
      }

      setState(() {
        // Convertir los resultados, asegurando que latitud y longitud sean doubles
        _resultados = resultados.map((ruta) {
          return {
            ...ruta,
            'latitud': _convertToDouble(ruta['latitud']),
            'longitud': _convertToDouble(ruta['longitud']),
          };
        }).toList();
        print(_resultados);
      });

      // Limpiar los puntos previos
      setState(() {
        _markers.clear();
        _polylines.clear();
      });

      // Añadir el punto inicial fijo con color amarillo
      _markers.add(Marker(
        markerId: MarkerId('punto_inicial'),
        position: _puntoInicial,
        infoWindow: InfoWindow(title: 'Punto Inicial'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      // Centrar el mapa en el punto inicial fijo
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(_puntoInicial, 14));

      // Añadir el primer marcador (punto inicial) a la ruta
      LatLng lastPoint = _puntoInicial;

      for (int i = 0; i < _resultados.length; i++) {
        var punto = _resultados[i];
        double lat = punto['latitud'];
        double lon = punto['longitud'];

        // Llamar a la función para obtener la ruta entre el último punto y el siguiente
        await _getRutaDeGoogle(
            lastPoint.latitude, lastPoint.longitude, lat, lon, '${i + 1}');

        // Actualizar el punto de inicio para la siguiente polilínea
        lastPoint = LatLng(lat, lon);
      }
    } catch (e) {
      print("Error al buscar en la base de datos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar en la base de datos: $e")),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Importar Cortes y Mostrar Ruta"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _codigoFijoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Código Ruta",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _buscarRutasPorCodigo,
            child: Text("Buscar y Mostrar Ruta"),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: _puntoInicial, // Inicializar siempre en el punto fijo
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          // Aquí añadimos una sección en la parte inferior para mostrar la distancia y el tiempo total
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Distancia Total: ${_calcularDistanciaTotal()}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Tiempo Estimado: ${_calcularTiempoTotal()}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
