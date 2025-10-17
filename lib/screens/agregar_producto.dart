import 'package:flutter/material.dart';
import '../services/inventario_service.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final codigoController = TextEditingController();
  final categoriaController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  final proveedorController = TextEditingController();

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'codigo_barras': codigoController.text,
        'categoria': categoriaController.text,
        'precio': precioController.text,
        'stock': stockController.text,
        'proveedor': proveedorController.text,
        'activo': '1', // Por defecto TRUE al crear
      };

      try {
        final success = await InventarioService.crearProducto(data);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto creado con éxito.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          // Si el backend devuelve status != 'ok' (ej: por código de barras repetido)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Revise el código de barras o campos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de red/servidor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Nuevo Producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de Barras (Único)',
                ),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: proveedorController,
                decoration: const InputDecoration(labelText: 'Proveedor'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) =>
                    (v!.isEmpty ||
                        double.tryParse(v) == null ||
                        double.parse(v) <= 0)
                    ? 'Precio debe ser > 0'
                    : null,
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => (v!.isEmpty || int.tryParse(v) == null)
                    ? 'Stock inválido'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarProducto,
                icon: const Icon(Icons.save),
                label: const Text('Crear Producto'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}