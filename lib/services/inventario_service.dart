import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class InventarioService {
  // ATENCIÓN: Usa 10.0.2.2 para emulador Android, o la IP de tu PC para un dispositivo real.
  static const String baseUrl = 'http://localhost/api_inventario/api.php';

  // Helper para construir el cuerpo de la petición con URL-encoding
  static String _encodeBody(Map<String, dynamic> params) {
    return Uri(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    ).query;
  }

  // ✅ READ: Listar todos los productos
  static Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=read',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar productos: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      // Captura errores de conexión o parsing
      throw Exception('Error de conexión o datos: $e');
    }
  }

  // ✅ CREATE: Agregar nuevos productos
  static Future<bool> crearProducto(Map<String, dynamic> data) async {
    final bodyData = _encodeBody({'action': 'create', ...data});

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: bodyData,
    );

    // Devolvemos true si la respuesta del backend es exitosa (status: ok)
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData['status'] == 'ok';
    }
    return false;
  }

  // ✅ UPDATE: Actualizar información de productos
  static Future<bool> actualizarProducto(
    int id,
    Map<String, dynamic> data,
  ) async {
    final bodyData = _encodeBody({
      'action': 'update',
      'id': id.toString(),
      ...data,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: bodyData,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData['status'] == 'ok';
    }
    return false;
  }

  // ✅ DELETE: Eliminar productos
  static Future<bool> eliminarProducto(int id) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'action=delete&id=$id',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData['status'] == 'ok';
    }
    return false;
  }
}