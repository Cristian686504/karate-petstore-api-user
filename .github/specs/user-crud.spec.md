# Spec: user-crud

**Status:** `IMPLEMENTED`

## Definition of Ready

- [x] dominio identificado → `user`
- [x] flujos/endpoints identificados → `POST /user`, `GET /user/{username}`, `PUT /user/{username}`, `DELETE /user/{username}`
- [x] criterios felices claros → solo happy path (5 flujos)
- [x] auth conocida → `api_key: special-key` (header bearer)
- [x] datos y restricciones descritos → modelo User con 8 campos

## Dominio

`user`

## Baseline

- Maven + Java 17 + Karate 1.5.2
- Scaffold pre-built ya existente en el repo
- Env default: `qa`
- baseUrl: `https://petstore.swagger.io/v2`

## Artefactos a crear

### 1. karate-config.js (MODIFICAR existente)

Agregar `baseUrl` apuntando a Petstore y objeto `paths` con las rutas del dominio `user`:

```js
baseUrl: 'https://petstore.swagger.io/v2',
paths: {
  createUser: '/user',
  getUser: '/user/',
  updateUser: '/user/',
  deleteUser: '/user/'
}
```

### 2. Data files — `src/test/resources/data/user/`

| Archivo | Contenido |
|---|---|
| `create-user.json` | Payload para POST /user (crear usuario) |
| `update-user.json` | Payload para PUT /user/{username} (actualizar nombre y email) |

### 3. Schemas — `src/test/resources/schemas/user/`

| Archivo | Uso |
|---|---|
| `user-response.json` | Schema del objeto User retornado por GET /user/{username} |
| `api-response.json` | Schema de respuesta genérica `{code, type, message}` para POST, PUT, DELETE |

### 4. Features — `src/test/java/template/user/`

5 features individuales (uno por acción) + 1 feature orquestador que los llama con `call`:

| Archivo | Acción | Método |
|---|---|---|
| `create-user.feature` | Crear usuario | `POST /user` |
| `get-user.feature` | Buscar usuario | `GET /user/{username}` |
| `update-user.feature` | Actualizar usuario | `PUT /user/{username}` |
| `get-updated-user.feature` | Buscar usuario actualizado | `GET /user/{username}` |
| `delete-user.feature` | Eliminar usuario | `DELETE /user/{username}` |
| `user-crud.feature` | Orquestador: llama los 5 features con `call` | — |

### 5. Runner — `src/test/java/template/user/UserRunner.java`

- Package: `template.user`
- Clase: `UserRunner`
- Usa `Karate.run("user-crud.feature").relativeTo(getClass())`

## Convenciones aplicadas

- Paths de API definidos en `karate-config.js`, NO hardcodeados en features
- Payloads leídos desde archivos JSON en `data/user/`
- Schemas reutilizables en `schemas/user/`
- Runner y features en la misma carpeta de dominio
- Tags: `@smoke`, `@regression`
- Auth vía header `api_key` con valor configurable
- Features individuales llamados con `call` desde el orquestador

## Fuera de alcance

- Flujos negativos
- `POST /user/createWithArray`, `POST /user/createWithList`
- `GET /user/login`, `GET /user/logout` como flujos independientes
- Dominios `pet` y `store`
