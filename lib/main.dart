import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:movil_system_si2/pages/lectura.dart';
import 'package:movil_system_si2/pages/reconexion.dart';

import 'pages/login.dart';
import 'pages/perfil.dart';
import 'pages/MenuCortes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // final pushProvider = new PushNotificationProvider();
    // pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/perfil': (context) => const PerfilPage(),
        '/lectura': (context)=>LecturaPage(),
        '/reconexion': (context)=>ReconexionPage(),
        '/MenuCortes': (context)=>MenuCortesPage()
        /*
        
        
        
        '/departamentos': (context) => const DepartamentosPage(),
        '/contrato': (context) => const ContratoEmpleadoPage(empleadoId: 1),
        '/postulantes': (context) => const PostulantesPage(),*/
        // Define más rutas para otras páginas si es necesario
      },
    );
  }
}
