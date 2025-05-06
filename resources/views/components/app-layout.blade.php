<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name', 'Laravel') }}</title>
    @vite('resources/css/app.css')
</head>
{{-- Cambiar bg-gray-100 y text-gray-900 (por defecto) a bg-gray-900 y text-gray-100 --}}
<body class="font-sans antialiased bg-gray-900 text-gray-100">
    <header>
        </header>

    <main class="py-4">
        {{ $slot }}
    </main>
</body>
</html>