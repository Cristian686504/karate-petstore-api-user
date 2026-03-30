# Conclusiones

## Resumen de ejecución

- **Feature**: CRUD de usuario en Petstore API
- **Sub-features**: 5 (create, get, update, get-updated, delete)
- **Resultado**: scenarios: 5 | passed: 5 | failed: 0
- **Tiempo de ejecución**: ~10 segundos (5 features standalone)
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

### 6. El patrón `call read()` permite setup reutilizable entre features

Usar `call read('create-user.feature')` como setup en cada feature permite:
- Que cada feature sea **auto-contenido** y ejecutable de forma independiente
- Reutilizar la lógica de creación sin duplicar pasos inline
- Ejecutar features en cualquier orden sin dependencias de estado
- Facilitar ejecución individual con runners dedicados por feature

### 7. Features standalone requieren setup y cleanup propios

Al eliminar el feature orquestador y hacer cada feature standalone, cada uno necesita:
- **Setup**: crear el usuario al inicio (vía `call read`)
- **Cleanup**: eliminar el usuario al final (inline)
- Esto garantiza que la ejecución paralela o en cualquier orden funcione correctamente

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
