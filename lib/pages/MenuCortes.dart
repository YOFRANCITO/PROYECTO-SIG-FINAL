import 'package:flutter/material.dart';
import 'package:movil_system_si2/pages/MenuCortespages/VerRutasBD.dart';
import 'package:movil_system_si2/pages/MenuCortespages/listaCorteRealizado.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';
import 'MenuCortespages/corte.dart';
import 'MenuCortespages/registroruta.dart';



class MenuCortesPage extends StatefulWidget {
  const MenuCortesPage({super.key});

  @override
  _MenuCortesPageState createState() => _MenuCortesPageState();
}

class _MenuCortesPageState extends State<MenuCortesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Opciones de Cortes'), // AppBar personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  CortesPage(),
                  ),
                );
              },
              child: const Text(
                "Importar cortes desde el servidor",
                style: TextStyle(color: Colors.black), // Color del texto negro
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  RutasMapa(),
                  ),
                );
              },
              child: const Text(
                "Registrar Cortes",
                style: TextStyle(color: Colors.black), // Color del texto negro
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
             const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  VerRutasBD(),
                  ),
                );
              },
              child: const Text(
                "Exportar Cortes al servidor",
                style: TextStyle(color: Colors.black), // Color del texto negro
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
           
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ListaCortePages(),
                  ),
                );
              },
              child: const Text(
                "Lista de cortes realizados",
                style: TextStyle(color: Colors.black), // Color del texto negro
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0), // Sidebar o Bottom Navigation Bar
    );
  }
}
