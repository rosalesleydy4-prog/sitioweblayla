import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';
import 'agregar_producto.dart';
import 'editar_producto.dart';
import 'detalle_producto.dart'; // Importamos la nueva pantalla

class ListaProductosScreen extends StatefulWidget {
  const ListaProductosScreen({super.key});

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  List<Producto> productos = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final productosObtenidos = await InventarioService.obtenerProductos();
      setState(() {
        productos = productosObtenidos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // Función para manejar la eliminación
  Future<void> _eliminarProducto(Producto producto) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${producto.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        final success = await InventarioService.eliminarProducto(producto.id);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado con éxito.'),
              backgroundColor: Colors.green,
            ),
          );
          cargarProductos(); // Recargar
        } else {
          throw Exception('La API no confirmó la eliminación');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Tienda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarProductos,
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navegar a la pantalla de agregar y recargar la lista al volver
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AgregarProductoScreen(),
            ),
          );
          cargarProductos();
        },
        label: const Text('Agregar Producto'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Lógica para mostrar los diferentes estados de la pantalla
  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Text('Error: $error \n Presiona el botón de recargar.'),
      );
    }
    if (productos.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos en inventario. Presiona "+" para agregar uno.',
        ),
      );
    }

    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            onTap: () {
              // Navegar a la pantalla de Detalle al hacer tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DetalleProductoScreen(producto: producto),
                ),
              );
            },
            leading: Icon(
              producto.stock < 10 ? Icons.error_outline : Icons.check_circle,
              color: producto.stock < 10 ? Colors.orange : Colors.green,
            ),
            title: Text(
              producto.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código: ${producto.codigoBarras} | Cat.: ${producto.categoria}',
                ),
                Text(
                  'Precio: \$${producto.precio.toStringAsFixed(2)} | Stock: ${producto.stock}',
                  style: TextStyle(
                    color: producto.stock < 10 ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    // Navegar a la pantalla de edición y recargar la lista al volver
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditarProductoScreen(producto: producto),
                      ),
                    );
                    cargarProductos();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _eliminarProducto(producto),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}