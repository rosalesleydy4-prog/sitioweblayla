<?php
// api.php - API REST para la Gestión de Inventario

include 'conexion.php'; 

$conexion = conectarDB();

// -----------------------------------------------------------------------------
// Funciones Auxiliares
// -----------------------------------------------------------------------------

function sendResponse($status, $message = '', $data = null) {
    header('Content-Type: application/json');
    echo json_encode(['status' => $status, 'message' => $message, 'data' => $data]);
    exit;
}

// -----------------------------------------------------------------------------
// Lógica de Peticiones (CRUD)
// -----------------------------------------------------------------------------

$action = isset($_POST['action']) ? $_POST['action'] : '';

switch ($action) {
    
    // =========================================================================
    // ✅ CREATE: Agregar nuevo producto
    // =========================================================================
    case 'create':
        // Recolección de datos
        $nombre = $_POST['nombre'] ?? '';
        $descripcion = $_POST['descripcion'] ?? '';
        $codigo_barras = $_POST['codigo_barras'] ?? '';
        $categoria = $_POST['categoria'] ?? '';
        $precio = $_POST['precio'] ?? 0;
        $stock = $_POST['stock'] ?? 0;
        $proveedor = $_POST['proveedor'] ?? '';
        $activo = $_POST['activo'] ?? '1';

        // Validaciones
        if (empty($nombre) || empty($descripcion) || empty($codigo_barras) || empty($categoria) || empty($proveedor) || !is_numeric($precio) || $precio <= 0) {
            sendResponse('error', 'Faltan campos obligatorios o el precio es inválido (debe ser > 0).');
            return;
        }

        // Preparar y ejecutar la inserción
        // --- TABLA: productos (PLURAL) ---
        $stmt = $conexion->prepare("INSERT INTO productos (nombre, descripcion, codigo_barras, categoria, precio, stock, proveedor, activo) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssdsss", $nombre, $descripcion, $codigo_barras, $categoria, $precio, $stock, $proveedor, $activo);

        if ($stmt->execute()) {
            sendResponse('ok', 'Producto creado con éxito.');
        } else {
            // Manejo de error de Código de Barras Único
            if ($conexion->errno == 1062) {
                 sendResponse('error', 'El código de barras ya existe. Debe ser único.');
            } else {
                 sendResponse('error', 'Error al crear el producto: ' . $stmt->error);
            }
        }
        $stmt->close();
        break;

    // =========================================================================
    // ✅ READ: Listar todos los productos
    // =========================================================================
    case 'read':
        // Consulta para obtener todos los campos
        // 🚨 CORRECCIÓN: Se usa 'productos' (PLURAL) para coincidir con la convención de la API.
        $query = "SELECT id, nombre, descripcion, codigo_barras, categoria, precio, stock, proveedor, fecha_ingreso, activo FROM productos ORDER BY nombre ASC";
        $resultado = $conexion->query($query);
        $productos = [];

        if ($resultado === false) {
             // Manejo de error si la consulta falla (p. ej. la tabla NO existe)
             sendResponse('error', 'Error en la consulta: ' . $conexion->error);
             return;
        }

        if ($resultado->num_rows > 0) {
            while ($fila = $resultado->fetch_assoc()) {
                // Formateo de datos
                $fila['precio'] = number_format($fila['precio'], 2, '.', ''); 
                $fila['activo'] = (int)$fila['activo'];
                $productos[] = $fila;
            }
            // Retorna el array de productos
            header('Content-Type: application/json');
            echo json_encode($productos);
            exit; 
        } else {
            // Si no hay resultados, devuelve un array vacío
            header('Content-Type: application/json');
            echo json_encode([]);
            exit;
        }
        break;

    // =========================================================================
    // ✅ UPDATE: Actualizar producto
    // =========================================================================
    case 'update':
        $id = $_POST['id'] ?? '';
        $nombre = $_POST['nombre'] ?? '';
        $descripcion = $_POST['descripcion'] ?? '';
        $categoria = $_POST['categoria'] ?? '';
        $precio = $_POST['precio'] ?? 0;
        $stock = $_POST['stock'] ?? 0;
        $proveedor = $_POST['proveedor'] ?? '';
        $activo = $_POST['activo'] ?? '1';
        
        // Validaciones
        if (empty($id) || empty($nombre) || empty($descripcion) || empty($categoria) || empty($proveedor) || !is_numeric($precio) || $precio <= 0) {
             sendResponse('error', 'Faltan campos obligatorios o el ID/precio es inválido.');
             return;
        }

        // Preparar y ejecutar la actualización
        // --- TABLA: productos (PLURAL) ---
        $stmt = $conexion->prepare("UPDATE productos SET nombre=?, descripcion=?, categoria=?, precio=?, stock=?, proveedor=?, activo=? WHERE id=?");
        $stmt->bind_param("sssdsisi", $nombre, $descripcion, $categoria, $precio, $stock, $proveedor, $activo, $id);

        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                sendResponse('ok', 'Producto actualizado con éxito.');
            } else {
                sendResponse('error', 'Ningún producto fue actualizado. El ID podría ser incorrecto o los datos son los mismos.');
            }
        } else {
            sendResponse('error', 'Error al actualizar: ' . $stmt->error);
        }
        $stmt->close();
        break;

    // =========================================================================
    // ✅ DELETE: Eliminar producto
    // =========================================================================
    case 'delete':
        $id = $_POST['id'] ?? '';

        if (empty($id)) {
            sendResponse('error', 'Se requiere el ID del producto.');
            return;
        }

        // Preparar y ejecutar la eliminación
        // --- TABLA: productos (PLURAL) ---
        $stmt = $conexion->prepare("DELETE FROM productos WHERE id=?");
        $stmt->bind_param("i", $id);

        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                sendResponse('ok', 'Producto eliminado con éxito.');
            } else {
                sendResponse('error', 'Ningún producto fue eliminado. ID no encontrado.');
            }
        } else {
            sendResponse('error', 'Error al eliminar: ' . $stmt->error);
        }
        $stmt->close();
        break;

    default:
        sendResponse('error', 'Acción no válida o no especificada.');
        break;
}

$conexion->close();
?>