<x-app-layout>
    {{-- Cambiar bg-gray-100 (del body) y text-gray-900 (del body) --}}
    <div class="container mx-auto px-4 py-6">
        <div class="flex justify-between items-center mb-6">
            {{-- Texto del título ahora será claro por el body --}}
            <h1 class="text-2xl font-bold">Productos</h1>
            {{-- Botón Crear Producto --}}
            <a href="{{ route('products.create') }}" class="bg-blue-700 text-white px-4 py-2 rounded hover:bg-blue-600 transition duration-200">
                Crear producto
            </a>
        </div>

        @if (session('success'))
            {{-- Mensaje de éxito para fondo oscuro --}}
            <div class="bg-green-800 text-green-200 p-4 rounded mb-4">
                {{ session('success') }}
            </div>
        @endif

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            @foreach ($products as $product)
                {{-- Tarjeta de producto: Fondo oscuro, sin sombra pronunciada --}}
                <div class="bg-gray-800 rounded-lg p-4 border border-gray-700">
                    @if ($product->image)
                        {{-- Asegurar que la imagen se vea bien --}}
                        <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" class="w-full h-48 object-cover rounded border border-gray-700">
                    @endif
                    {{-- Texto del nombre del producto --}}
                    <h2 class="mt-2 text-xl font-semibold text-white">{{ $product->name }}</h2>
                    {{-- Texto de la descripción --}}
                    <p class="text-gray-300">{{ $product->description }}</p>
                    {{-- Texto del precio --}}
                    <p class="text-green-400 font-bold mt-2">${{ $product->price }}</p>
                    <div class="flex justify-between mt-4">
                        {{-- Enlaces de acción --}}
                        <a href="{{ route('products.edit', $product) }}" class="text-blue-500 hover:underline">Editar</a>
                        <form action="{{ route('products.destroy', $product) }}" method="POST" onsubmit="return confirm('¿Seguro que quieres eliminar este producto?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-500 hover:underline">Eliminar</button>
                        </form>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
</x-app-layout>