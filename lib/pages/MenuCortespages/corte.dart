import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_system_si2/pages/MenuCortespages/importarcortes.dart';
// ignore: depend_on_referenced_packages
import 'package:xml/xml.dart';

class CortesPage extends StatefulWidget {
  @override
  _CortesPageState createState() => _CortesPageState();
}

class _CortesPageState extends State<CortesPage> {
  String? _selectedRoute = "Seleccionar...";
  List<String> _routes = ["Seleccionar...", "TODAS LAS RUTAS"];
  final TextEditingController _codigoFijoController = TextEditingController();
  String _serverResponse = "";
  List<Map<String, String>> _tablesData = []; // Almacena datos procesados

  @override
  void dispose() {
    _codigoFijoController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    final url = "http://190.171.244.211:8080/wsVarios/wsBS.asmx";

    // Validar el valor del input
    final codigoFijoText = _codigoFijoController.text.trim();
    if (codigoFijoText.isEmpty && _selectedRoute != "TODAS LAS RUTAS") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa un código fijo válido.")),
      );
      return;
    }

    final codigoFijo = int.tryParse(codigoFijoText) ?? 0;
    final liCper = _selectedRoute == "TODAS LAS RUTAS" ? 0 : codigoFijo;

    final soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
          <liCper>$liCper</liCper>
        </W0Corte_ObtenerRutas>
      </soap:Body>
    </soap:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://activebs.net/W0Corte_ObtenerRutas",
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        print("Respuesta completa del servidor: ${response.body}");
        _parseSoapResponse(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar datos: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor: $e")),
      );
    }
  }

  void _parseSoapResponse(String response) {
    final startTag = "<diffgr:diffgram";
    final endTag = "</diffgr:diffgram>";

    print("Respuesta para procesar: $response");

    if (!response.contains(startTag) || !response.contains(endTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se encontraron datos válidos en la respuesta.")),
      );
      return;
    }

    final rawXml = response.substring(
      response.indexOf(startTag),
      response.indexOf(endTag) + endTag.length,
    );

    try {
      final document = XmlDocument.parse(rawXml);
      final tables = document.findAllElements('Table');

      if (tables.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se encontraron tablas en la respuesta.")),
        );
        return;
      }

      List<Map<String, String>> parsedData = [];
      List<String> routes = [];

      for (var table in tables) {
        final bsrutnrut = table.getElement('bsrutnrut')?.text ?? "N/A";
        final dNomb = table.getElement('dNomb')?.text?.trim() ?? "N/A";
        final bsrutdesc = table.getElement('bsrutdesc')?.text?.trim() ?? "N/A";
        final bsrutabrv = table.getElement('bsrutabrv')?.text?.trim() ?? "N/A";
        final bsrutfcor = table.getElement('bsrutfcor')?.text?.trim() ?? "N/A";
        final bsrutcper = table.getElement('bsrutcper')?.text?.trim() ?? "N/A";

        parsedData.add({
          "Número Ruta": bsrutnrut,
          "Nombre": dNomb,
          "Descripción": bsrutdesc,
          "Abreviatura": bsrutabrv,
          "Fecha": bsrutfcor,
          "Código de Usuario": bsrutcper,
        });

        if (bsrutdesc != "N/A" && !routes.contains(bsrutdesc)) {
          routes.add(bsrutdesc);
        }
      }

      setState(() {
        _tablesData = parsedData;

        if (_selectedRoute == "TODAS LAS RUTAS") {
          _routes = ["Seleccionar...", "TODAS LAS RUTAS", ...routes];
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Datos cargados correctamente.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar datos del servidor: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cortes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedRoute,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoute = newValue;
                });
                if (_selectedRoute == "TODAS LAS RUTAS" || _selectedRoute != "Seleccionar...") {
                  _sendData();
                }
              },
              items: _routes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codigoFijoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Código Fijo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _sendData,
                  child: Text("Cargar Rutas"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImportarCortesPage(),
                      ),
                    );
                  },
                  child: Text("Importar Cortes"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tablesData.length,
                itemBuilder: (context, index) {
                  final table = _tablesData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Número Ruta: ${table["Número Ruta"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Nombre: ${table["Nombre"]}"),
                          Text("Descripción: ${table["Descripción"]}"),
                          Text("Abreviatura: ${table["Abreviatura"]}"),
                          Text("Fecha: ${table["Fecha"]}"),
                          Text("Código de Usuario: ${table["Código de Usuario"]}"),
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
