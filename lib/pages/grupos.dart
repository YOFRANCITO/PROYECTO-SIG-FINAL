 import 'package:flutter/material.dart';
import '../Services/grupohoraService.dart';
import '../Services/gruposService.dart';
import '../models/grupohora.dart'; // Asegúrate de importar los modelos adecuadamente
import '../components/appBar.dart';
import '../components/barMenu.dart';

class GruposPage extends StatefulWidget {
  @override
  _GruposPageState createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  late Future<List<Grupo2>> futureGrupos;

  @override
  void initState() {
    super.initState();
    futureGrupos = GrupoService().fetchGrupos();
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
                "Programacion Academica",
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
    return FutureBuilder<List<Grupo2>>(
      future: futureGrupos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No hay datos'));
        } else {
          List<Grupo2> grupos = snapshot.data!;
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
                        'Carrera: ${grupo.carreraNombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Gestión: ${grupo.gestionNombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Materia: ${grupo.materiaNombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Usuario: ${grupo.ourUsersNombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Sistema Académico: ${grupo.sistemaacademicoNombre}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Horarios:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: grupo.horarios.map((horario) => buildHorarioWidget(horario)).toList(),
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

  Widget buildHorarioWidget(Horario horario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Día: ${horario.dia}',
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          'Hora Inicio: ${horario.horainicio}',
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          'Hora Fin: ${horario.horafin}',
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          'Aula: ${horario.aulaNombre}',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}






//  import 'package:flutter/material.dart';
//  import '../Services/grupohoraService.dart';
//  import '../models/grupohora.dart';
//  import '../components/appBar.dart';
//  import '../components/barMenu.dart';

//  class GruposPage extends StatefulWidget {
//    @override
//    _GruposPageState createState() => _GruposPageState();
//  }

//  class _GruposPageState extends State<GruposPage> {
//    late Future<List<Grupo2>> futureGrupos;
//    int? _selectedGrupoId;  Variable para almacenar el ID del grupo seleccionado

//    @override
//    void initState() {
//      super.initState();
//      futureGrupos = GrupoService().fetchGrupos();
//      _selectedGrupoId = null;  Inicializa como null para no tener valor seleccionado al inicio
//    }

//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: CustomAppBar(title: 'Grupos'),
//        body: Container(
//          width: double.infinity,
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.topCenter,
//              colors: [
//                Colors.blue.shade900,
//                Colors.blue.shade800,
//                Colors.lightBlue.shade400,
//              ],
//            ),
//          ),
//          child: Column(
//            children: <Widget>[
//              SizedBox(height: 20),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                child: Text(
//                  "Grupos",
//                  style: TextStyle(color: Colors.white, fontSize: 30),
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  margin: EdgeInsets.only(top: 20),
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(30),
//                      topRight: Radius.circular(30),
//                    ),
//                  ),
//                  child: Padding(
//                    padding: EdgeInsets.all(20),
//                    child: buildGruposList(),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//        bottomNavigationBar: BottomNavBar(selectedIndex: 3),
//      );
//    }

//    Widget buildGruposList() {
//      return FutureBuilder<List<Grupo2>>(
//        future: futureGrupos,
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.waiting) {
//            return Center(child: CircularProgressIndicator());
//          } else if (snapshot.hasError) {
//            return Center(child: Text('Error: ${snapshot.error}'));
//          } else if (!snapshot.hasData) {
//            return Center(child: Text('No hay datos'));
//          } else {
//            List<Grupo2> grupos = snapshot.data!;
//            return DropdownButton<int>(
//              value: _selectedGrupoId,
//              hint: Text('Selecciona un grupo'),  Texto mostrado cuando no hay nada seleccionado
//              items: grupos.map((grupo) {
//                return DropdownMenuItem<int>(
//                  value: grupo.id,
//                  child: Text(
//                    '${grupo.nombre} - ${grupo.materiaNombre} - ${grupo.horarios.isNotEmpty ? "${grupo.horarios.first.horainicio} - ${grupo.horarios.first.horafin}" : "Horario no disponible"}',
//                  ),
//                );
//              }).toList(),
//              onChanged: (value) {
//                setState(() {
//                  _selectedGrupoId = value;
//                });
//                print('Grupo seleccionado: $_selectedGrupoId');
//              },
//            );
//          }
//        },
//      );
//    }
//  }
