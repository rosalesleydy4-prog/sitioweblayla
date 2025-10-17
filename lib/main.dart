import 'package:flutter/material.dart';
import 'screens/lista_producto.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Inventario',
      theme: ThemeData(
        // Cambiamos el color primario a Teal para un tema de inventario
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 211, 72, 233),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 121, 0, 89),
          foregroundColor: Colors.white,
        ),
      ),
      // La pantalla de inicio es la lista de productos
      home: const ListaProductosScreen(),
    );
  }
}
