<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use App\Models\Categoria;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    /**
     * Muestra el dashboard principal con estadísticas
     */
    public function index()
    {
        // Estadísticas generales
        $totalProductos = Producto::count();
        $totalCategorias = Categoria::count();
        $stockTotal = Producto::sum('stock');
        $productosActivos = Producto::where('activo', true)->count();
        
        // Productos con stock bajo (menos de 10 unidades)
        $productosStockBajo = Producto::where('stock', '<', 10)
            ->where('activo', true)
            ->orderBy('stock', 'asc')
            ->get();
        
        // Últimos 5 productos creados
        $productosRecientes = Producto::with('categoria')
            ->latest()
            ->take(5)
            ->get();
        
        // Categorías con conteo de productos
        $categorias = Categoria::withCount('productos')
            ->orderBy('productos_count', 'desc')
            ->get();
        
        return view('welcome', compact(
            'totalProductos',
            'totalCategorias',
            'stockTotal',
            'productosActivos',
            'productosStockBajo',
            'productosRecientes',
            'categorias'
        ));
    }
}
