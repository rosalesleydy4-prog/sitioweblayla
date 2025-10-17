-- SCRIPT SQL PARA EL SISTEMA DE GESTIÓN DE INVENTARIO DE TIENDA
-- Base de Datos: flutter_inventario_tienda  <-- ¡CAMBIADO!
-- Tabla: producto  <-- ¡CAMBIADO!

-- 1. Crear la base de datos (si no existe) y seleccionarla
CREATE DATABASE IF NOT EXISTS inventario_tienda;
USE inventario_tienda;

-- 2. Creación de la tabla 'producto'
-- Contiene todas las restricciones requeridas: PRIMARY KEY, UNIQUE, NOT NULL, DEFAULT
CREATE TABLE IF NOT EXISTS productos (  <-- ¡TABLA CAMBIADA!
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL, 
    categoria VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    proveedor VARCHAR(150) NOT NULL,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE 
);

-- 3. Inserción de Datos de Ejemplo (5 productos obligatorios)
-- NOTA: La tabla de inserción también debe ser 'producto'
INSERT INTO productos (nombre, descripcion, codigo_barras, categoria, precio, stock, proveedor, activo) VALUES <-- ¡TABLA CAMBIADA!
('iPhone 15 Pro', 'Smartphone Apple de alta gama con chip A17 Bionic.', 'P001AAPL15', 'Celulares', 1200.00, 25, 'Apple Inc.', TRUE),
('Samsung Galaxy S24', 'Smartphone Samsung insignia con IA integrada.', 'P002SAMGS24', 'Celulares', 999.99, 15, 'Samsung Electronics', TRUE),
('MacBook Air M2', 'Laptop ultradelgada de Apple con chip M2.', 'P003AAPLMA', 'Computadoras', 1199.00, 8, 'Apple Inc.', TRUE),
('AirPods Pro', 'Audífonos inalámbricos con cancelación de ruido.', 'P004AAPLAP', 'Accesorios', 249.00, 40, 'Apple Inc.', TRUE),
('iPad Air', 'Tablet Apple de gran potencia para creativos.', 'P005AAPLIA', 'Tablets', 599.00, 12, 'Tablets S.A.', TRUE);