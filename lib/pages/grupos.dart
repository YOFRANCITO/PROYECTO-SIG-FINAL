// grupos_page.dart
import 'package:flutter/material.dart';
import '../Services/gruposService.dart';
import '../models/GrupoModel.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class GruposPage extends StatefulWidget {
  @override
  _GruposPageState createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  late Future<List<Grupo>> futureGrupos;

  @override
  void initState() {
    super.initState();
    futureGrupos = ApiService().fetchGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Grupos'),
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
                "Grupos",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
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
                  child: buildGruposList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 3),
    );
  }

  Widget buildGruposList() {
    return FutureBuilder<List<Grupo>>(
      future: futureGrupos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No hay datos'));
        } else {
          List<Grupo> grupos = snapshot.data!;
          return ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              final grupo = grupos[index];
              return Card(
                color: Colors.blue[800],
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    grupo.nombre,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cupo: ${grupo.cupo}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Materia: ${grupo.materia.nombre} (${grupo.materia.sigla})',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Carrera: ${grupo.carrera.nombre} (${grupo.carrera.nro})',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Facultad: ${grupo.carrera.facultad.nombre} (${grupo.carrera.facultad.codigo})',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Usuario: ${grupo.ourUser.name} (${grupo.ourUser.email})',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Gestión: ${grupo.gestion.nombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Sistema Académico: ${grupo.sistemaAcademico.nombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
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
