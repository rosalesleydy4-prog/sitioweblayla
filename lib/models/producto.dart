class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final String codigoBarras;
  final String categoria;
  final double precio;
  final int stock;
  final String proveedor;
  final String fechaIngreso;
  final bool activo;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.codigoBarras,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.proveedor,
    required this.fechaIngreso,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      codigoBarras: json['codigo_barras'] ?? '',
      categoria: json['categoria'] ?? '',
      // Se maneja la conversión de String a Double/Int de forma segura
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      proveedor: json['proveedor'] ?? '',
      fechaIngreso: json['fecha_ingreso'] ?? '',
      // Se asume que el backend envía '1' o '0'
      activo: json['activo'].toString() == '1' || json['activo'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'nombre': nombre,
      'descripcion': descripcion,
      'codigo_barras': codigoBarras,
      'categoria': categoria,
      'precio': precio.toString(),
      'stock': stock.toString(),
      'proveedor': proveedor,
      'activo': activo ? '1' : '0', // Enviar como string '1' o '0' al backend
    };
  }
}