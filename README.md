# Karate Petstore API — CRUD de Usuario

## Descripción

Proyecto de automatización de pruebas API usando **Karate 1.5.2** sobre **Maven** y **Java 17**. Cubre el flujo completo CRUD (Create, Read, Update, Delete) del dominio **User** en la API [Petstore Swagger](https://petstore.swagger.io/).

## Estructura del proyecto

```
pom.xml                                              # Configuración Maven + Karate 1.5.2
mvnw / mvnw.cmd                                      # Maven Wrapper
src/test/java/karate-config.js                        # Configuración global (baseUrl, paths, apiKey)
src/test/java/logback-test.xml                        # Configuración de logging
src/test/java/template/user/UserRunner.java           # Runner general — ejecuta todas las features del dominio
src/test/java/template/user/CreateUserRunner.java     # Runner individual — create-user
src/test/java/template/user/GetUserRunner.java        # Runner individual — get-user
src/test/java/template/user/UpdateUserRunner.java     # Runner individual — update-user
src/test/java/template/user/GetUpdatedUserRunner.java # Runner individual — get-updated-user
src/test/java/template/user/DeleteUserRunner.java     # Runner individual — delete-user
src/test/java/template/user/create-user.feature       # Feature: crear usuario (POST)
src/test/java/template/user/get-user.feature          # Feature: buscar usuario (GET)
src/test/java/template/user/update-user.feature       # Feature: actualizar usuario (PUT)
src/test/java/template/user/get-updated-user.feature  # Feature: verificar datos actualizados (GET)
src/test/java/template/user/delete-user.feature       # Feature: eliminar usuario (DELETE)
src/test/resources/data/user/create-user.json         # Payload para crear usuario
src/test/resources/data/user/update-user.json         # Payload para actualizar usuario
src/test/resources/schemas/user/user-response.json    # Schema del objeto User
src/test/resources/schemas/user/api-response.json     # Schema de respuesta genérica API
src/test/resources/helpers/auth/                       # Helpers de autenticación
src/test/resources/helpers/common.js                   # Utilidades comunes
```

## Prerequisitos

- **Java 17** o superior instalado
- Variable de entorno `JAVA_HOME` configurada
- Conexión a internet (la API es pública)

## Instrucciones de ejecución paso a paso

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd karate-petstore-api-user
```

### 2. Ejecutar todas las pruebas

```bash
# Linux/Mac
./mvnw test

# Windows
.\mvnw.cmd test
```

### 3. Ejecutar solo las pruebas del dominio User

```bash
# Linux/Mac
./mvnw test -Dtest=template.user.UserRunner

# Windows
.\mvnw.cmd test "-Dtest=template.user.UserRunner"
```

### 4. Ejecutar una feature individual

```bash
# Ejemplo: solo crear usuario
.\mvnw.cmd test "-Dtest=template.user.CreateUserRunner"

# Ejemplo: solo eliminar usuario
.\mvnw.cmd test "-Dtest=template.user.DeleteUserRunner"
```

### 5. Ejecutar por tags

```bash
# Solo pruebas @smoke
.\mvnw.cmd test "-Dkarate.options=--tags @smoke"

# Solo pruebas @regression
.\mvnw.cmd test "-Dkarate.options=--tags @regression"
```

### 6. Ejecutar con un ambiente específico

```bash
.\mvnw.cmd test "-Dkarate.env=qa"
```

### 7. Ver el reporte HTML

Después de ejecutar las pruebas, abrir en el navegador:

```
target/karate-reports/karate-summary.html
```

## Arquitectura de features

El proyecto usa **5 features standalone** (uno por acción CRUD). Cada feature es **auto-contenido**: incluye su propio setup y cleanup usando `call read()` para reutilizar `create-user.feature` como precondición.

```
create-user.feature       → POST /user (feature base, reutilizado por los demás)
get-user.feature          → call create-user + GET /user/{username} + cleanup
update-user.feature       → call create-user + GET userId + PUT /user/{username} + cleanup
get-updated-user.feature  → call create-user + update inline + GET /user/{username} + cleanup
delete-user.feature       → call create-user + DELETE /user/{username}
```

### Runners disponibles

| Runner | Alcance |
|---|---|
| `UserRunner` | Ejecuta todas las features del dominio |
| `CreateUserRunner` | Solo `create-user.feature` |
| `GetUserRunner` | Solo `get-user.feature` |
| `UpdateUserRunner` | Solo `update-user.feature` |
| `GetUpdatedUserRunner` | Solo `get-updated-user.feature` |
| `DeleteUserRunner` | Solo `delete-user.feature` |

## Casos de prueba implementados

| # | Caso | Método | Endpoint | Feature | Validación |
|---|---|---|---|---|---|
| 1 | Crear usuario | `POST` | `/user` | `create-user.feature` | Status 200, schema `api-response.json` |
| 2 | Buscar usuario creado | `GET` | `/user/{username}` | `get-user.feature` | Status 200, schema `user-response.json`, datos coinciden |
| 3 | Actualizar nombre y correo | `PUT` | `/user/{username}` | `update-user.feature` | Status 200, schema `api-response.json` |
| 4 | Buscar usuario actualizado | `GET` | `/user/{username}` | `get-updated-user.feature` | Status 200, `firstName` y `email` actualizados |
| 5 | Eliminar usuario | `DELETE` | `/user/{username}` | `delete-user.feature` | Status 200, schema `api-response.json` |

## Variables y configuración

| Variable | Valor | Ubicación |
|---|---|---|
| `baseUrl` | `https://petstore.swagger.io/v2` | `karate-config.js` |
| `apiKey` | `special-key` | `karate-config.js` |
| `paths.createUser` | `/user` | `karate-config.js` |
| `paths.getUser` | `/user/` | `karate-config.js` |
| `paths.updateUser` | `/user/` | `karate-config.js` |
| `paths.deleteUser` | `/user/` | `karate-config.js` |

## Datos de prueba

**Creación** (`data/user/create-user.json`):
```json
{
  "username": "karate_user",
  "firstName": "Karate",
  "lastName": "Tester",
  "email": "karate@test.com",
  "password": "pass123",
  "phone": "1234567890",
  "userStatus": 1
}
```

**Actualización** (`data/user/update-user.json`):
```json
{
  "username": "karate_user",
  "firstName": "KarateUpdated",
  "lastName": "Tester",
  "email": "karate_updated@test.com",
  "password": "pass123",
  "phone": "1234567890",
  "userStatus": 1
}
```

## Tecnologías

- **Karate** 1.5.2
- **Java** 17
- **Maven** (con wrapper incluido)
- **JUnit 5** (integración con Karate)