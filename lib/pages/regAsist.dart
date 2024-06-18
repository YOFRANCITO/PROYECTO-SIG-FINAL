import 'package:flutter/material.dart';
import '../Services/asistenciaallService.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class AsistenciasPage extends StatefulWidget {
  @override
  _AsistenciasPageState createState() => _AsistenciasPageState();
}

class _AsistenciasPageState extends State<AsistenciasPage> {
  late Future<List<AsistenciaModel>> futureAsistencias;
  String filtroEstado = ""; // Estado inicial

  @override
  void initState() {
    super.initState();
    futureAsistencias = AsistenciaService2().fetchGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Asistencias'),
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Reporte de Asistencias",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filtroEstado = "Presente"; // Mostrar presentes
                    });
                  },
                  child: Text('Presentes'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filtroEstado = "Falta"; // Mostrar faltas
                    });
                  },
                  child: Text('Faltas'),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filtroEstado = "Atraso"; // Mostrar retrasos
                    });
                  },
                  child: Text('Retrasos'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filtroEstado = "virtual"; // Mostrar virtuales
                    });
                  },
                  child: Text('Virtuales'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: buildAsistenciasList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 3),
    );
  }

  Widget buildAsistenciasList() {
    return FutureBuilder<List<AsistenciaModel>>(
      future: futureAsistencias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No hay datos'));
        } else {
          List<AsistenciaModel> asistencias = snapshot.data!;
          // Filtrar asistencias según el estado
          List<AsistenciaModel> filteredAsistencias = asistencias.where((asistencia) => asistencia.descripcion.contains(filtroEstado)).toList();
          return ListView.builder(
            itemCount: filteredAsistencias.length,
            itemBuilder: (context, index) {
              final asistencia = filteredAsistencias[index];
              return Card(
                color: Colors.blue[800],
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    asistencia.descripcion,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hora: ${asistencia.hora}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Fecha: ${asistencia.fecha}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Tiempo: ${asistencia.tiempo}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Estado: ${asistencia.estado}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      // Text(
                      //   'Latitud: ${asistencia.latitud}',
                      //   style: TextStyle(color: Colors.white70),
                      // ),
                      // Text(
                      //   'Longitud: ${asistencia.longitud}',
                      //   style: TextStyle(color: Colors.white70),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
