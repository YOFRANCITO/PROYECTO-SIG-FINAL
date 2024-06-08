// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class Horario extends StatefulWidget {
  @override
  _HorarioState createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  String _selectedDay = DateFormat('EEEE', 'es_ES').format(DateTime.now());
  final Map<String, List<Materia>> materiasPorDia = {
    'lunes': [
      Materia('Matemáticas', 'MAT110', 'SA', '7:00 - 9:00', '21', 7, 9),
      Materia('Física', 'FIS101', 'SB', '9:00 - 11:00', '22', 9, 11),
    ],
    'martes': [
      Materia('Química', 'QUI202', 'SC', '11:00 - 1:00', '23', 11, 13),
    ],
    // Agrega más materias para otros días
  };

  final List<String> daysOfWeek = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBar(title: 'Mis Horarios'),
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
                "Horario de Clases",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedDay,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_downward, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.blue.shade800,
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                    });
                  },
                  items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
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
                  child: buildHorario(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2,),
    );
  }

  Widget buildHorario() {
    final List<Materia> materias = materiasPorDia[_selectedDay] ?? [];

    return ListView.builder(
      itemCount: 15, // De 7am a 10pm son 15 horas
      itemBuilder: (context, index) {
        final hour = 7 + index;
        final materia = materias.firstWhere(
          (materia) => materia.startHour <= hour && materia.endHour > hour,
          orElse: () => Materia('', '', '', '', '', 0, 0),
        );

        return Row(
          children: <Widget>[
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '$hour:00',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 10),
            if (materia.nombre.isNotEmpty)
              Expanded(
                child: Card(
                  color: Colors.blue[800],
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      materia.nombre,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${materia.sigla} - Grupo: ${materia.grupo} - ${materia.horario} - Aula: ${materia.aula}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            if (materia.nombre.isEmpty)
              Expanded(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        );
      },
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
