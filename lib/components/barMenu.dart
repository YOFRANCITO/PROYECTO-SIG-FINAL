// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const BottomNavBar({Key? key, required this.selectedIndex}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/perfil');
        break;
      case 1:
        Navigator.pushNamed(context, '/marcarAsist');
        break;
      // case 2:
      //   Navigator.pushNamed(context, '/horarios');
      //   break;
      case 2:
        Navigator.pushNamed(context, '/grupos');
        break;
      case 3:
        Navigator.pushNamed(context, '/asistencias');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue.shade900,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          label: 'Asistencia',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.schedule),
        //   label: 'Horarios',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Programacion',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Registro',
        ),
      ],
    );
  }
}
