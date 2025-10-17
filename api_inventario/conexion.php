<?php
// conexion.php

// Define las constantes de conexión
define('DB_HOST', 'localhost');
define('DB_USER', 'root'); // Usuario predeterminado de XAMPP
define('DB_PASS', '');     // Contraseña predeterminada de XAMPP
define('DB_NAME', 'inventario_tienda'); // <--- ¡BD CORRECTA!

// Establece la conexión
function conectarDB() {
    $conexion = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    // Verifica si la conexión falló
    if ($conexion->connect_error) {
        die("Error de conexión a la base de datos: " . $conexion->connect_error);
    }
    
    // Configura el charset
    $conexion->set_charset("utf8");

    return $conexion;
}

// Permite peticiones CORS desde Flutter
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

?>