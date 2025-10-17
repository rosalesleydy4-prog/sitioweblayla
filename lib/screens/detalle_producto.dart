import 'package:flutter/material.dart';
import '../models/producto.dart';

class DetalleProductoScreen extends StatelessWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  // Widget auxiliar para tarjetas de detalle
  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(label),
      ),
    );
  }

  // Widget auxiliar para tarjetas de valor clave (Precio/Stock)
  Widget _buildValueCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              producto.nombre,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 10),

            _buildDetailCard(
              icon: Icons.description,
              label: 'Descripción',
              value: producto.descripcion,
            ),

            // Indicadores de Inventario y Precio
            Row(
              children: [
                Expanded(
                  child: _buildValueCard(
                    icon: Icons.attach_money,
                    label: 'Precio',
                    value: '\$${producto.precio.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildValueCard(
                    icon: Icons.inventory,
                    label: 'Stock Actual',
                    value: producto.stock.toString(),
                    color: producto.stock < 10 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Otros Metadatos
            _buildDetailCard(
              icon: Icons.qr_code,
              label: 'Código de Barras',
              value: producto.codigoBarras,
            ),
            _buildDetailCard(
              icon: Icons.category,
              label: 'Categoría',
              value: producto.categoria,
            ),
            _buildDetailCard(
              icon: Icons.local_shipping,
              label: 'Proveedor',
              value: producto.proveedor,
            ),
            _buildDetailCard(
              icon: Icons.check_circle_outline,
              label: 'Estado',
              value: producto.activo ? 'Activo' : 'Inactivo',
            ),
            _buildDetailCard(
              icon: Icons.access_time,
              label: 'Fecha de Ingreso',
              value: producto.fechaIngreso.split(' ')[0],
            ),
          ],
        ),
      ),
    );
  }
}