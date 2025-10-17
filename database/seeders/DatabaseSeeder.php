<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Categoria;
use App\Models\Producto;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Desactivar verificación de llaves foráneas temporalmente
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        
        // Limpiar tablas
        Producto::truncate();
        Categoria::truncate();
        
        // Reactivar verificación de llaves foráneas
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // Crear Categorías
        $smartphones = Categoria::create([
            'nombre' => 'Smartphones',
            'descripcion' => 'Teléfonos inteligentes de última generación'
        ]);

        $laptops = Categoria::create([
            'nombre' => 'Laptops',
            'descripcion' => 'Computadoras portátiles para trabajo y entretenimiento'
        ]);

        $accesorios = Categoria::create([
            'nombre' => 'Accesorios',
            'descripcion' => 'Accesorios y periféricos tecnológicos'
        ]);

        // ========== CREAR PRODUCTOS - SMARTPHONES ==========
        
        Producto::create([
            'nombre' => 'iPhone 15 Pro',
            'descripcion' => 'Smartphone Apple con chip A17 Pro, cámara de 48MP y pantalla Super Retina XDR de 6.1 pulgadas',
            'precio' => 1199.99,
            'stock' => 25,
            'categoria_id' => $smartphones->id,
            'codigo_barras' => 'IPH15PRO001',
            'imagen' => 'https://images.unsplash.com/photo-1678685888221-cda773a3dcdb?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'Samsung Galaxy S24',
            'descripcion' => 'Smartphone Samsung con procesador Snapdragon 8 Gen 3, 12GB RAM y pantalla Dynamic AMOLED 2X',
            'precio' => 999.99,
            'stock' => 30,
            'categoria_id' => $smartphones->id,
            'codigo_barras' => 'SAMS24001',
            'imagen' => 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'Google Pixel 8 Pro',
            'descripcion' => 'Smartphone Google con IA avanzada, cámara de 50MP, procesador Tensor G3 y 12GB RAM',
            'precio' => 899.99,
            'stock' => 8,
            'categoria_id' => $smartphones->id,
            'codigo_barras' => 'GPIX8PRO001',
            'imagen' => 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400',
            'activo' => true
        ]);

        // ========== CREAR PRODUCTOS - LAPTOPS ==========
        
        Producto::create([
            'nombre' => 'MacBook Air M2',
            'descripcion' => 'Laptop Apple con chip M2, 8GB RAM, 256GB SSD y pantalla Liquid Retina de 13.6 pulgadas',
            'precio' => 1299.99,
            'stock' => 20,
            'categoria_id' => $laptops->id,
            'codigo_barras' => 'MBAM2001',
            'imagen' => 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'Dell XPS 13',
            'descripcion' => 'Laptop Dell con Intel Core i7 de 13va gen, 16GB RAM, 512GB SSD y pantalla InfinityEdge',
            'precio' => 1399.99,
            'stock' => 12,
            'categoria_id' => $laptops->id,
            'codigo_barras' => 'DELLXPS13001',
            'imagen' => 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'HP Pavilion 15',
            'descripcion' => 'Laptop HP con AMD Ryzen 5, 8GB RAM, 512GB SSD, pantalla Full HD de 15.6 pulgadas',
            'precio' => 699.99,
            'stock' => 5,
            'categoria_id' => $laptops->id,
            'codigo_barras' => 'HPPAV15001',
            'imagen' => 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400',
            'activo' => true
        ]);

        // ========== CREAR PRODUCTOS - ACCESORIOS ==========
        
        Producto::create([
            'nombre' => 'AirPods Pro',
            'descripcion' => 'Auriculares inalámbricos Apple con cancelación activa de ruido y audio espacial',
            'precio' => 249.99,
            'stock' => 40,
            'categoria_id' => $accesorios->id,
            'codigo_barras' => 'AIRPRO001',
            'imagen' => 'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'Logitech MX Master 3',
            'descripcion' => 'Mouse inalámbrico ergonómico para productividad, con sensor de 4000 DPI y batería recargable',
            'precio' => 99.99,
            'stock' => 35,
            'categoria_id' => $accesorios->id,
            'codigo_barras' => 'LOGIMX3001',
            'imagen' => 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
            'activo' => true
        ]);

        Producto::create([
            'nombre' => 'Samsung Galaxy Watch 6',
            'descripcion' => 'Smartwatch con pantalla AMOLED, monitoreo de salud avanzado y GPS integrado',
            'precio' => 349.99,
            'stock' => 18,
            'categoria_id' => $accesorios->id,
            'codigo_barras' => 'SAMWATCH6001',
            'imagen' => 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400',
            'activo' => true
        ]);

        // Mensaje de confirmación en consola
        $this->command->info('✅ Base de datos poblada exitosamente!');
        $this->command->info('📦 3 Categorías creadas');
        $this->command->info('🎁 9 Productos creados');
    }
}