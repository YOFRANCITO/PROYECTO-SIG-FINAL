// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class SolicitarPermisoPage extends StatefulWidget {
  @override
  _SolicitarPermisoPageState createState() => _SolicitarPermisoPageState();
}

class _SolicitarPermisoPageState extends State<SolicitarPermisoPage> {
  String selectedSubject = "Matemáticas";
  DateTime selectedDate = DateTime.now();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _justificacionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Solicitar Permiso'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Solicitar Permiso de Inasistencia",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: selectedSubject,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSubject = newValue!;
                            });
                          },
                          items: <String>['Matemáticas', 'Ciencias', 'Historia']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            "Fecha de inasistencia: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(Icons.calendar_today, color: Colors.blue.shade900),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _codigoController,
                          decoration: InputDecoration(
                            hintText: "Ingrese su Código de docente",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _justificacionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Escriba su justificación",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          // Aquí se debería enviar la solicitud al backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Permiso solicitado para la fecha ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                            ),
                          );
                        },
                        height: 50,
                        color: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Solicitar Permiso",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }
}
