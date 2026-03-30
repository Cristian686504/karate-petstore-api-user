# Conclusiones

## Resumen de ejecución

- **Feature**: CRUD de usuario en Petstore API
- **Sub-features**: 5 (create, get, update, get-updated, delete)
- **Resultado**: scenarios: 1 | passed: 1 | failed: 0
- **Tiempo de ejecución**: ~3.68 segundos (tiempo de feature)
- **Framework**: Karate 1.5.2 + JUnit 5 + Maven

## Hallazgos

### 1. La API Petstore ignora el campo `id` en la creación

Al enviar `"id": 0` en el `POST /user`, la API asigna automáticamente un ID interno de alto rango (ej: `9223372036854773364`). El campo `id` del payload es ignorado y la API genera su propio identificador.

### 2. El `PUT /user/{username}` requiere el ID real para actualizar correctamente

Al enviar `"id": 0` en el payload de actualización, la API puede crear un registro nuevo en lugar de actualizar el existente. Para que la actualización funcione correctamente, es necesario capturar el `id` asignado en la creación (vía `GET`) y enviarlo en el payload del `PUT`.

### 3. La API mantiene estado persistente entre ejecuciones

Los datos no se limpian automáticamente entre ejecuciones de pruebas. Un usuario creado en una ejecución anterior sigue existiendo en la siguiente. Esto requiere un paso de **cleanup** previo (DELETE) al inicio del flujo para garantizar resultados consistentes e idempotentes.

### 4. Las respuestas de mutación usan un schema genérico

Los endpoints `POST`, `PUT` y `DELETE` retornan el mismo schema genérico `{ code, type, message }` en lugar del objeto `User`. El campo `message` contiene el ID numérico del usuario (en creación/actualización) o el `username` (en eliminación).

### 5. La autenticación con `api_key` es opcional en la práctica

Aunque la especificación Swagger define `api_key` como mecanismo de seguridad, la API Petstore funciona sin enviar este header. Las pruebas lo incluyen igualmente por buenas prácticas y para reflejar el contrato documentado.

### 6. El patrón `call` permite features modulares y reutilizables

Separar cada operación CRUD en su propio `.feature` y orquestarlos desde un feature principal con `call` permite:
- Reutilizar features individuales en otros flujos
- Pasar parámetros dinámicos entre features (ej: `userId`, `username`)
- Mantener cada feature enfocado en una sola responsabilidad
- Facilitar el mantenimiento independiente de cada operación

### 7. Los escenarios CRUD son inherentemente secuenciales

Dado que cada paso depende del anterior (no se puede buscar sin crear, no se puede actualizar sin que exista, etc.), el patrón correcto es un único Scenario en el feature orquestador que encadena las llamadas con `call`. Esto garantiza el orden de ejecución y permite compartir estado entre pasos.

## Validaciones realizadas

| Paso | Feature | Validación | Resultado |
|---|---|---|---|
| Crear usuario | `create-user.feature` | Status 200 + schema `api-response` | OK |
| Buscar usuario | `get-user.feature` | Status 200 + schema `user-response` + datos coinciden | OK |
| Actualizar usuario | `update-user.feature` | Status 200 + schema `api-response` | OK |
| Buscar actualizado | `get-updated-user.feature` | Status 200 + `firstName` y `email` actualizados | OK |
| Eliminar usuario | `delete-user.feature` | Status 200 + schema `api-response` | OK |

## Reporte

El reporte HTML generado por Karate se encuentra en:

```
target/karate-reports/karate-summary.html
```
