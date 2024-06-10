// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class MateriasPage extends StatefulWidget {
  @override
  _MateriasPageState createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  final List<Materia> materias = [
    Materia(
      'Matemáticas',
      'MAT110',
      'SA',
      [
        Dia('Lunes', '07:00', '09:00', '21'),
        Dia('Miércoles', '07:00', '09:00', '22'),
      ],
    ),
    Materia(
      'Física',
      'FIS101',
      'SB',
      [
        Dia('Martes', '09:00', '11:00', '23'),
        Dia('Jueves', '09:00', '11:00', '24'),
      ],
    ),
    // Agrega más materias aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Materias'),
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
                "Materias",
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
                  child: buildMateriasList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 3),
    );
  }

  Widget buildMateriasList() {
    return ListView.builder(
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];

        return Card(
          color: Colors.blue[800],
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
              materia.nombre,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sigla: ${materia.sigla}',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  'Grupo: ${materia.grupo}',
                  style: TextStyle(color: Colors.white70),
                ),
                ...materia.dias.map((dia) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      '${dia.dia}: ${dia.horaInicio} - ${dia.horaFin}, Aula: ${dia.aula}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Materia {
  final String nombre;
  final String sigla;
  final String grupo;
  final List<Dia> dias;

  Materia(this.nombre, this.sigla, this.grupo, this.dias);
}

class Dia {
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String aula;

  Dia(this.dia, this.horaInicio, this.horaFin, this.aula);
}
