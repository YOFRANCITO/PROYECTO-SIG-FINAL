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
        Navigator.pushNamed(context, '/lectura');
        break;

      case 2:
        Navigator.pushNamed(context, '/MenuCortes');
        break;
      case 3:
        Navigator.pushNamed(context, '/reconexion');
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
          label: 'Lectura',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Cortes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Reconexion',
        ),
       
      ],
    );
  }
}
