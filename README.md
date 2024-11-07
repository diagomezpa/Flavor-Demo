# FlavorBox

FlavorBox es una aplicación Flutter diseñada para gestionar recetas. Los usuarios pueden agregar, ver, editar y eliminar recetas. Cada receta contiene un nombre, una lista de ingredientes y una descripción.

## Estructura del Proyecto

- **models**: Contiene la clase modelo `Recipe`.
- **services**: Contiene la clase `DatabaseHelper` para operaciones de base de datos.
- **screens**: Contiene las pantallas de la interfaz de usuario como `HomeScreen`, `DetailScreen` y `FormScreen`.

## Descripción del Diseño

### Modelos

- **Recipe**: Representa una receta con un ID, nombre, ingredientes y descripción. Incluye métodos para convertir a y desde un mapa para operaciones de base de datos.

### Servicios

- **DatabaseHelper**: Gestiona la base de datos SQLite. Incluye métodos para inicializar la base de datos, crear tablas, insertar, obtener y eliminar recetas.

### Pantallas

- **HomeScreen**: Muestra una lista de recetas. Los usuarios pueden agregar una nueva receta usando un botón que navega a la `FormScreen`.
- **DetailScreen**: Muestra los detalles de una receta seleccionada. Los usuarios pueden editar o eliminar la receta.
- **FormScreen**: Permite a los usuarios ingresar o editar los detalles de la receta, incluyendo el nombre, ingredientes y descripción.

## Consideraciones Importantes

1. **Inicialización de la Base de Datos**: La base de datos se inicializa de manera perezosa cuando se accede por primera vez. La clase `DatabaseHelper` asegura que se use una única instancia de la base de datos en toda la aplicación.
2. **Gestión del Estado**: El estado de la lista de recetas se gestiona usando `FutureBuilder` en la `HomeScreen`. Cuando se agrega o elimina una receta, el estado se actualiza para reflejar los cambios.
3. **Navegación**: La navegación entre pantallas se maneja usando `Navigator.push` y `Navigator.pop`. Los datos se pasan entre pantallas usando el mecanismo de resultado del `Navigator`.
4. **Gestión de Ingredientes**: Los ingredientes se gestionan como una lista de cadenas. Se muestran en una lista horizontal y se pueden agregar, editar o eliminar usando diálogos.

## Uso

1. **Agregar una Receta**: Toca el botón "Agregar Nueva Receta" en la `HomeScreen` para navegar a la `FormScreen`. Llena los detalles y guarda.
2. **Ver Detalles de la Receta**: Toca una tarjeta de receta en la `HomeScreen` para navegar a la `DetailScreen`.
3. **Editar una Receta**: En la `DetailScreen`, toca el botón "Editar" para navegar a la `FormScreen` con detalles prellenados.
4. **Eliminar una Receta**: En la `DetailScreen`, toca el botón "Eliminar" para eliminar la receta y regresar a la `HomeScreen`.

## Dependencias

- `sqflite`: Para operaciones de base de datos SQLite.
- `path`: Para manejar rutas de archivos.

## Mejoras Futuras

- Agregar autenticación de usuario para gestionar colecciones personales de recetas.
- Implementar funcionalidad de búsqueda para encontrar recetas rápidamente.
- Mejorar la interfaz de usuario con más elementos interactivos y animaciones.
