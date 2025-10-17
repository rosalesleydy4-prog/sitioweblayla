import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;
  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController codigoController;
  late TextEditingController categoriaController;
  late TextEditingController precioController;
  late TextEditingController stockController;
  late TextEditingController proveedorController;
  late bool activo;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    nombreController = TextEditingController(text: p.nombre);
    descripcionController = TextEditingController(text: p.descripcion);
    codigoController = TextEditingController(text: p.codigoBarras);
    categoriaController = TextEditingController(text: p.categoria);
    precioController = TextEditingController(text: p.precio.toString());
    stockController = TextEditingController(text: p.stock.toString());
    proveedorController = TextEditingController(text: p.proveedor);
    activo = p.activo;
  }

  Future<void> _actualizarProducto() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'codigo_barras': codigoController.text,
        'categoria': categoriaController.text,
        'precio': precioController.text,
        'stock': stockController.text,
        'proveedor': proveedorController.text,
        'activo': activo ? '1' : '0',
      };

      try {
        final success = await InventarioService.actualizarProducto(
          widget.producto.id,
          data,
        );
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto actualizado con éxito.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: La API no pudo actualizar el producto.'),
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
      appBar: AppBar(title: Text('Editar: ${widget.producto.nombre}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // El ID y Código de Barras no se editan en este CRUD simple
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de Barras',
                ),
                readOnly: true,
              ),
              TextFormField(
                controller: categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: proveedorController,
                decoration: const InputDecoration(labelText: 'Proveedor'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
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
              SwitchListTile(
                title: const Text('Producto Activo/Inactivo'),
                value: activo,
                onChanged: (bool value) {
                  setState(() {
                    activo = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _actualizarProducto,
                icon: const Icon(Icons.save),
                label: const Text('Actualizar Producto'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
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