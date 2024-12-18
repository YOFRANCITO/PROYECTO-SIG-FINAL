import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Registrarcortes extends StatefulWidget {
  final String nombre;
  final String codUbicacion;
  final String codFijo;
  final String medidorSerie;
  final int idCorte;
  const Registrarcortes(
      {super.key,
      required this.nombre,
      required this.codUbicacion,
      required this.codFijo,
      required this.medidorSerie,
      required this.idCorte});

  @override
  State<Registrarcortes> createState() => _RegistrarcortesState();
}

class _RegistrarcortesState extends State<Registrarcortes> {
  late Database _database;
  Future<void> _updateDatabase(
      int id, String digiteLectura, String estado) async {
    try {
      // Actualizar los datos en la tabla 'rutast' filtrando por el 'id'
      int count = await _database.update(
        'rutast', // Nombre de la tabla
        {
          'digite_lectura': digiteLectura,
          'estado': estado,
        },
        where: 'id = ?', // Filtro: actualiza donde el id coincide
        whereArgs: [id], // Valor del id para filtrar
      );

      if (count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados para el id: $id')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se encontró ningún registro con el id: $id')),
        );
      }
    } catch (e) {
      print('Error al actualizar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar datos: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'base2.db'), // Usamos p.join aquí
      version: 1,
    );
  }

  String? _imagePath;
  // Capturar imagen con la cámara
  Future<void> _captureAndUpdateImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // Guarda la imagen en una carpeta local
      final savedImagePath = await _saveImageLocally(imageFile);

      // Actualiza la URL de la imagen en la base de datos
      int idToUpdate =
          widget.idCorte; // Cambia este ID según el registro que deseas actualizar
      await _updateImagePathInDatabase(savedImagePath, idToUpdate);

      // Actualiza la UI con la nueva ruta
      setState(() {
        _imagePath = savedImagePath;
      });
    } else {
      print("No se seleccionó ninguna imagen.");
    }
  }

// Guardar imagen localmente
  Future<String> _saveImageLocally(File imageFile) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String newPath = p.join(directory.path, "images");
    await Directory(newPath).create(recursive: true);

    final String fileName = p.basename(imageFile.path);
    final String savedPath = p.join(newPath, fileName);

    await imageFile.copy(savedPath);
    print("Imagen guardada en: $savedPath");

    return savedPath; // Retorna la ruta de la imagen guardada
  }

  // Guardar URL de la imagen en SQLite
  Future<void> _updateImagePathInDatabase(String imagePath, int id) async {
    try {
      // Actualiza el campo 'image_url' donde el id coincide
      int count = await _database.update(
        'rutast', // Nombre de la tabla
        {'image_url': imagePath}, // Campo a actualizar con el nuevo valor
        where: 'id = ?', // Condición para identificar el registro
        whereArgs: [id], // Argumentos de la condición
      );

      if (count == 0) {
        print("No se encontró ningún registro con ID $id para actualizar.");
      } else {
        print("Ruta actualizada en la base de datos para ID $id: $imagePath");
      }
    } catch (e) {
      print("Error al actualizar la URL de la imagen: $e");
    }
  }

// Mostrar imagen desde la ruta
  Widget _buildImageWidget() {
    if (_imagePath == null) {
      return Text("No hay imagen seleccionada.");
    } else {
      return Image.file(File(_imagePath!));
    }
  }

  String? _selectedOption; // Variable para almacenar la opción seleccionada
  final List<String> _options = ["Ninguno", "Observacion"]; // Lista de opciones
  TextEditingController _digiteCodigoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 80),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Cod. Ubic: ${widget.codUbicacion}'),
                      Text('Cod. Fijo: ${widget.codFijo}')
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Nombre: ${widget.nombre}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            'Digite Lectura:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              //height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 0.17,
                  ),
                ],
              ),
              child: TextFormField(
                controller: _digiteCodigoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Digite los valores del medidor',
                ),
              ),
            ),
          ),
          Divider(),
          DropdownButton<String>(
            hint: Text("Seleccione una opción"),
            value: _selectedOption, // Valor seleccionado
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue; // Actualiza la opción seleccionada
              });
            },
            items: _options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
          Divider(),
          ElevatedButton(
            onPressed: () {
              //Logica para guardar
              print(widget.idCorte);
              _updateDatabase(widget.idCorte, _digiteCodigoController.text,
                  _selectedOption.toString());
            },
            child: Text('Grabar Corte'),
          ),
          ElevatedButton(
            onPressed: _captureAndUpdateImage,
            child: Text('Capturar medidor'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              //Logica para guardar
            },
            child: Text('Volver al menu'),
          ),
        ],
      ),
    );
  }
}