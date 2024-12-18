import 'package:flutter/material.dart';
import 'package:movil_system_si2/pages/MenuCortespages/registrarcortes.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class VerRutasBD extends StatefulWidget {
  @override
  _VerRutasBDState createState() => _VerRutasBDState();
}

class _VerRutasBDState extends State<VerRutasBD> {
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
        where: 'nro_ruta = ?',
        whereArgs: [rutaFinal],
      );

      setState(() {
        _resultados = resultados;
      });

      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("No se encontraron resultados para esta ruta.")),
        );
      }
    } catch (e) {
      print("Error al buscar la ruta: $e");
    }
  }

  // Nueva función para verificar si una imagen existe
  Future<bool> _imageExists(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return false;
    return File(imagePath).exists();
  }

  Future<void> _exportarCortePorRuta() async {
    int count = 0;
    for (var ruta in _resultados) {
      print(
          "Exportando ruta ID: ${ruta['id']} con Medidor: ${ruta['medidor_serie']}");

      await _exportarCorte(
        liNcoc: ruta['medidor_serie'],
        liCemc: 6272,
        ldFcor: DateTime.now(),
        liPres: 50,
        liCobc: ruta['id'],
        liLcor: 100,
        liNofn: 1,
        lsAppName: "AppGrupoD",
      );

      count++;
    }

    print("Total exportados: $count");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Se exportaron $count datos correctamente.")),
    );
  }

  Future<void> _exportarCorte({
    required String liNcoc,
    required int liCemc,
    required DateTime ldFcor,
    required int liPres,
    required int liCobc,
    required int liLcor,
    required int liNofn,
    required String lsAppName,
  }) async {
    final url = "http://190.171.244.211:8080/wsVarios/wsBS.asmx";
    final soapAction = "\"http://activebs.net/W3Corte_UpdateCorte\"";

    final soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
               xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W3Corte_UpdateCorte xmlns="http://activebs.net/">
      <liNcoc>$liNcoc</liNcoc>
      <liCemc>$liCemc</liCemc>
      <ldFcor>${ldFcor.toIso8601String()}</ldFcor>
      <liPres>$liPres</liPres>
      <liCobc>$liCobc</liCobc>
      <liLcor>$liLcor</liLcor>
      <liNofn>$liNofn</liNofn>
      <lsAppName><![CDATA[$lsAppName]]></lsAppName>
    </W3Corte_UpdateCorte>
  </soap:Body>
</soap:Envelope>
'''
        .trim();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": soapAction,
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        print("Exportación exitosa para ID: $liCobc.");
      } else {
        print("Error al exportar datos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
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
      appBar: AppBar(
        title: Text("Exportar Cortes al servidor"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input y Dropdown
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      labelText: "Código de ruta",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _rutaSeleccionada,
                    hint: Text("Seleccione una ruta"),
                    isExpanded: true,
                    items: _rutasUnicas.map((String ruta) {
                      return DropdownMenuItem<String>(
                        value: ruta,
                        child: Text(ruta),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _rutaSeleccionada = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distribuir elementos a los extremos
              children: [
                // Botón Buscar
                ElevatedButton(
                  onPressed: _buscarRuta,
                  child: Text("Buscar"),
                ),

                ElevatedButton(
                  onPressed: _exportarCortePorRuta,
                  child: Text("Exportar Datos"),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Resultados con imágenes
            Expanded(
              child: _resultados.isEmpty
                  ? Center(child: Text("No se han encontrado resultados."))
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final ruta = _resultados[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Registrarcortes(
                                    nombre: ruta['nombre'],
                                    codFijo: ruta['cf'],
                                    codUbicacion: ruta['cu'],
                                    medidorSerie: ruta['medidor_serie'],
                                    idCorte: ruta['id'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${ruta['id']}"),
                                  Text("Nro. ruta: ${ruta['nro_ruta']}"),
                                  Text("Latitud: ${ruta['latitud']}"),
                                  Text("Nombre: ${ruta['nombre']}"),
                                  Text("nro_corte: ${ruta['nro_corte']}"),
                                  Text(
                                      "Medidor serie: ${ruta['medidor_serie']}"),
                                  Text("Longitud: ${ruta['longitud']}"),
                                  Text("C.U: ${ruta['cu']}"),
                                  Text("C.F: ${ruta['cf']}"),
                                  Text("Estado: ${ruta['estado']}"),
                                  Divider(color: Colors.black),
                                  Text("Captura del medidor:"),
                                  FutureBuilder<bool>(
                                    future: _imageExists(ruta['image_url']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError ||
                                          !(snapshot.data ?? false)) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child:
                                              Text("No hay imagen disponible."),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Image.file(
                                            File(ruta['image_url']),
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
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