import 'package:flutter/material.dart';
import '../components/appBar.dart';
import '../components/barMenu.dart';

class LecturaPage extends StatelessWidget {
  const LecturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Lectura'), // AppBar personalizado
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Center(
          child: Text(
            "Buscando...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0), // Sidebar
    );
  }
}
