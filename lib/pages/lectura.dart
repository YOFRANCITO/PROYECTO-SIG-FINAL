import 'package:flutter/material.dart';
import 'package:movil_system_si2/pages/MenuCortespages/registrarcortes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../components/appBar.dart'; // AppBar personalizado
import '../components/barMenu.dart'; // Barra de navegación personalizada

class LecturaPage extends StatefulWidget {
  @override
  _RegistroRutasState createState() => _RegistroRutasState();
}

class _RegistroRutasState extends State<LecturaPage> {
  late Database _database;
  List<Map<String, dynamic>> _resultados = [];
  List<String> _rutasUnicas = [];
  String? _rutaSeleccionada;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'base2.db'),
      version: 1,
    );
    _obtenerRutasUnicas();
  }

  Future<void> _obtenerRutasUnicas() async {
    try {
      final List<Map<String, dynamic>> rutas = await _database.rawQuery(
        'SELECT DISTINCT nro_ruta FROM rutast',
      );
      setState(() {
        _rutasUnicas = rutas.map((e) => e['nro_ruta'].toString()).toList();
      });
    } catch (e) {
      print("Error al obtener rutas únicas: $e");
    }
  }

  Future<void> _buscarRuta() async {
    String? rutaFinal;

    if (_inputController.text.isNotEmpty) {
      rutaFinal = _inputController.text.trim();
    } else if (_rutaSeleccionada != null) {
      rutaFinal = _rutaSeleccionada;
    }

    if (rutaFinal == null || rutaFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingrese o seleccione una ruta.")),
      );
      return;
    }

    try {
      final resultados = await _database.query(
        'rutast',
        where: 'nro_ruta = ? AND estado = ?',
        whereArgs: [rutaFinal, "Ninguno"], // Solo incluir donde estado sea 'ninguno'
      );

      setState(() {
        _resultados = resultados;
      });

      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se realizaron lecturas para esta ruta aún.")),
        );
      }
    } catch (e) {
      print("Error al buscar la ruta: $e");
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Lecturas'), // AppBar personalizado
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila con el inputbox y el menú desplegable
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: "Código de ruta",
                        labelStyle: TextStyle(color: Colors.white), // Texto blanco
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // Texto blanco
                    ),
                  ),
                  SizedBox(width: 16), // Espaciado entre columnas
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _rutaSeleccionada,
                      hint: Text(
                        "Seleccione una ruta",
                        style: TextStyle(color: Colors.white), // Texto blanco
                      ),
                      isExpanded: true,
                      items: _rutasUnicas.map((String ruta) {
                        return DropdownMenuItem<String>(
                          value: ruta,
                          child: Text(ruta, style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _rutaSeleccionada = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Botón Buscar
              ElevatedButton(
                onPressed: _buscarRuta,
                child: Text("Buscar"),
              ),
              SizedBox(height: 20),

              // Resultados
              Expanded(
                child: _resultados.isEmpty
                    ? Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _resultados.length,
                        itemBuilder: (context, index) {
                          final ruta = _resultados[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${ruta['id']}"),
                                  Text("Nro. ruta: ${ruta['nro_ruta']}"),
                                  Text("Latitud: ${ruta['latitud']}"),
                                  Text("Nombre: ${ruta['nombre']}"),
                                  Text("Medidor serie: ${ruta['medidor_serie']}"),
                                  Text("Longitud: ${ruta['longitud']}"),
                                  Text("C.U: ${ruta['cu']}"),
                                  Text("C.F: ${ruta['cf']}"),
                                  Text("Estado: ${ruta['estado']}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0), // Barra personalizada
    );
  }
}
