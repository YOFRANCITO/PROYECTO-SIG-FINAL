import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p; // Cambiamos el import de 'path'

class RegistroRutas extends StatefulWidget {
  @override
  _RegistroRutasState createState() => _RegistroRutasState();
}

class _RegistroRutasState extends State<RegistroRutas> {
  late Database _database;
  final TextEditingController _latitudController = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'rutast.db'), // Usamos p.join aquí
      version: 1,
    );
  }

  Future<void> _buscarRutasPorLatitud() async {
    final latitudBuscada = _latitudController.text.trim();
    if (latitudBuscada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingrese un valor de ruta.")),
      );
      return;
    }

    try {
      final resultados = await _database.query(
        'rutast',
        where: 'nro_ruta = ?',
        whereArgs: [latitudBuscada],
      );

      setState(() {
        _resultados = resultados;
      });

      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se encontraron rutas ingresada.")),
        );
      }
    } catch (e) {
      print("Error al buscar en la base de datos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar en la base de datos.")),
      );
    }
  }

  @override
  void dispose() {
    _latitudController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Rutas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _latitudController,
              decoration: InputDecoration(
                labelText: "Código de ruta",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarRutasPorLatitud,
              child: Text("Buscar"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _resultados.isEmpty
                  ? Center(child: Text("No se han encontrado resultados."))
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
                                Text("Longitud: ${ruta['longitud']}"),
                                Text("C.U: ${ruta['cu']}"),
                                Text("C.F: ${ruta['cf']}"),
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
    );
  }
}
