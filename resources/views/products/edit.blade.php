<x-app-layout>
    <div class="container mx-auto px-4 py-6">
        {{-- Texto del título --}}
        <h1 class="text-2xl font-bold mb-6">Editar Producto</h1>

        {{-- Formulario: Fondo oscuro, sin sombra pronunciada --}}
        <form action="{{ route('products.update', $product) }}" method="POST" enctype="multipart/form-data" class="bg-gray-800 rounded-lg p-6 border border-gray-700">
            @csrf
            @method('PUT')

            <div class="mb-4">
                {{-- Etiqueta de texto --}}
                <label class="block text-gray-300">Nombre</label>
                {{-- Campo de entrada: Fondo oscuro, borde claro, texto claro --}}
                <input type="text" name="name" value="{{ old('name', $product->name) }}" class="w-full border-gray-700 bg-gray-900 text-gray-100 rounded-lg mt-1 focus:border-blue-500 focus:ring focus:ring-blue-500 focus:ring-opacity-50">
                @error('name')
                    {{-- Texto de error --}}
                    <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                {{-- Etiqueta de texto --}}
                <label class="block text-gray-300">Descripción</label>
                {{-- Área de texto: Fondo oscuro, borde claro, texto claro --}}
                <textarea name="description" class="w-full border-gray-700 bg-gray-900 text-gray-100 rounded-lg mt-1 focus:border-blue-500 focus:ring focus:ring-blue-500 focus:ring-opacity-50">{{ old('description', $product->description) }}</textarea>
                @error('description')
                    {{-- Texto de error --}}
                    <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                {{-- Etiqueta de texto --}}
                <label class="block text-gray-300">Precio</label>
                {{-- Campo de número: Fondo oscuro, borde claro, texto claro --}}
                <input type="number" name="price" step="0.01" value="{{ old('price', $product->price) }}" class="w-full border-gray-700 bg-gray-900 text-gray-100 rounded-lg mt-1 focus:border-blue-500 focus:ring focus:ring-blue-500 focus:ring-opacity-50">
                @error('price')
                    {{-- Texto de error --}}
                    <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                {{-- Etiqueta de texto --}}
                <label class="block text-gray-300">Imagen</label>
                {{-- Campo de archivo: Ajustar estilos si es necesario --}}
                <input type="file" name="image" class="w-full border-gray-700 bg-gray-900 text-gray-100 rounded-lg mt-1 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                @if($product->image)
                    <div class="mt-2">
                        {{-- Imagen actual: Asegurar que se vea bien --}}
                        <img src="{{ asset('storage/' . $product->image) }}" alt="Imagen actual" class="w-32 h-32 object-cover rounded border border-gray-700">
                    </div>
                @endif
                @error('image')
                    {{-- Texto de error --}}
                    <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex justify-end">
                {{-- Botón Actualizar --}}
                <button type="submit" class="bg-blue-700 text-white px-4 py-2 rounded hover:bg-blue-600 transition duration-200">Actualizar</button>
            </div>
        </form>
    </div>
</x-app-layout>