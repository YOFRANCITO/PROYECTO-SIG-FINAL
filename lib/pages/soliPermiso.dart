// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../components/appBar.dart';
// import '../components/barMenu.dart';
// import '../services/licenciaService.dart';

// class SolicitarPermisoPage extends StatefulWidget {
//   @override
//   _SolicitarPermisoPageState createState() => _SolicitarPermisoPageState();
// }

// class _SolicitarPermisoPageState extends State<SolicitarPermisoPage> {
//   String selectedSubject = "Matemáticas";
//   DateTime selectedDate = DateTime.now();
//   final TextEditingController _codigoController = TextEditingController();
//   final TextEditingController _justificacionController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Solicitar Permiso'),
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             colors: [
//               Colors.blue.shade900,
//               Colors.blue.shade800,
//               Colors.lightBlue.shade400,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text(
//                   "Solicitar Permiso de Inasistencia",
//                   style: TextStyle(color: Colors.white, fontSize: 30),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(30),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: DropdownButton<String>(
//                           value: selectedSubject,
//                           isExpanded: true,
//                           icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
//                           underline: SizedBox(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedSubject = newValue!;
//                             });
//                           },
//                           items: <String>['Matemáticas', 'Ciencias', 'Historia']
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           title: Text(
//                             "Fecha de inasistencia: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           trailing: Icon(Icons.calendar_today, color: Colors.blue.shade900),
//                           onTap: () => _selectDate(context),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: _codigoController,
//                           decoration: InputDecoration(
//                             hintText: "Ingrese su Código de docente",
//                             hintStyle: TextStyle(color: Colors.grey),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.all(10),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: _justificacionController,
//                           maxLines: 5,
//                           decoration: InputDecoration(
//                             hintText: "Escriba su justificación",
//                             hintStyle: TextStyle(color: Colors.grey),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.all(10),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       MaterialButton(
//                         onPressed: () {
//                           // Aquí se debería enviar la solicitud al backend
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Permiso solicitado para la fecha ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
//                             ),
//                           );
//                         },
//                         height: 50,
//                         color: Colors.blue.shade900,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Solicitar Permiso",
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(selectedIndex: 1),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/licenciaService.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';
import '../services/grupohoraService.dart';
import '../models/grupohora.dart';

class SolicitarPermisoPage extends StatefulWidget {
  @override
  _SolicitarPermisoPageState createState() => _SolicitarPermisoPageState();
}

class _SolicitarPermisoPageState extends State<SolicitarPermisoPage> {
  late Future<List<Grupo2>> futureGrupos;
  int? _selectedGrupoId;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _justificacionController = TextEditingController();

  int? userId; // Variable para almacenar el ID del usuario

  @override
  void initState() {
    super.initState();
    futureGrupos = GrupoService().fetchGrupos();
    _loadUserId(); // Cargar el ID del usuario al inicializar la página
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id');
    setState(() {}); // Actualizar la UI una vez que se carga el ID del usuario
  }

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

  void _registrarLicencia() async {
    String descripcion = _justificacionController.text;
    String hora = DateFormat('HH:mm:ss').format(DateTime.now());
    DateTime fecha = selectedDate;

    if (_selectedGrupoId != null && userId != null) { // Verificar que tengamos el userId
      Grupo3 grupo = Grupo3(id: _selectedGrupoId!);

      // Crear instancia de OurUser2 con el ID del usuario
      OurUser2 usuario = OurUser2(id: userId!);

      Licencia2 nuevaLicencia = Licencia2(
        descripcion: descripcion,
        hora: hora,
        fecha: fecha,
        grupo: grupo,
        ourUser: usuario, // Asignar el objeto OurUser2 a la licencia
      );

      RegistrarLicencia2 servicio = RegistrarLicencia2();
      Map<String, dynamic> respuesta = await servicio.registrarLicencia(nuevaLicencia);

      if (respuesta.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${respuesta['error']}\nDetalles: ${respuesta['details']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso solicitado correctamente')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un grupo')),
      );
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
                  "Solicitar Permiso",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
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
                      FutureBuilder<List<Grupo2>>(
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
                            return DropdownButton<int>(
                              value: _selectedGrupoId,
                              hint: Text('Selecciona un grupo'),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
                              underline: SizedBox(),
                              items: grupos.map((grupo) {
                                return DropdownMenuItem<int>(
                                  value: grupo.id,
                                 child: Text(
                                      '${grupo.horarios.first.aulaNombre} ${grupo.nombre} - ${grupo.materiaNombre} - ${grupo.horarios.first.dia}- ${grupo.horarios.isNotEmpty ? "${grupo.horarios.first.horainicio} - ${grupo.horarios.first.horafin}" : "Horario no disponible"}',
                                    ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGrupoId = value;
                                });
                                print('Grupo seleccionado: $_selectedGrupoId');
                              },
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _justificacionController,
                        decoration: InputDecoration(
                          hintText: "Justificación",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Fecha Seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today, color: Colors.blue.shade900),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: _registrarLicencia,
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
