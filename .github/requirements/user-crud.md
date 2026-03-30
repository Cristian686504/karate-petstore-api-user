# Requerimiento: CRUD de Usuario Petstore

## Dominio

`user`

## Objetivo

Automatizar el flujo completo CRUD de usuario en la API Petstore, cubriendo únicamente el happy path: creación, consulta, actualización (nombre y correo), consulta del usuario actualizado y eliminación.

## Sistema bajo prueba

- Tipo: `API`
- Base path o capability: `https://petstore.swagger.io/v2`
- Ambientes relevantes: `qa`

## Flujos a cubrir

### 1. Crear usuario

`POST /user`

Validar:

- Respuesta exitosa con código `200`
- Body de respuesta contiene `"message"` con el ID del usuario creado

Entradas:

```json
{
  "id": 0,
  "username": "karate_user",
  "firstName": "Karate",
  "lastName": "Tester",
  "email": "karate@test.com",
  "password": "pass123",
  "phone": "1234567890",
  "userStatus": 1
}
```

### 2. Buscar el usuario creado

`GET /user/{username}`

Validar:

- Respuesta exitosa con código `200`
- Body contiene los datos del usuario creado: `username`, `firstName`, `lastName`, `email`

Entradas:

- `username`: `karate_user`

### 3. Actualizar nombre y correo del usuario

`PUT /user/{username}`

Validar:

- Respuesta exitosa con código `200`
- Body de respuesta contiene `"message"` confirmando la operación

Entradas:

- `username` (path): `karate_user`
- Body con campos actualizados:

```json
{
  "id": 0,
  "username": "karate_user",
  "firstName": "KarateUpdated",
  "lastName": "Tester",
  "email": "karate_updated@test.com",
  "password": "pass123",
  "phone": "1234567890",
  "userStatus": 1
}
```

### 4. Buscar el usuario actualizado

`GET /user/{username}`

Validar:

- Respuesta exitosa con código `200`
- `firstName` es `KarateUpdated`
- `email` es `karate_updated@test.com`

Entradas:

- `username`: `karate_user`

### 5. Eliminar usuario

`DELETE /user/{username}`

Validar:

- Respuesta exitosa con código `200`
- Body de respuesta contiene `"message"` con el username eliminado

Entradas:

- `username`: `karate_user`

## Auth

- Estrategia conocida: `bearer`
- Detalle adicional: La API Petstore permite usar la api key `special-key` en el header `api_key` para autorización

## Datos y contratos

- Datos sintéticos requeridos: payload de creación y de actualización del usuario (listados en los flujos)
- Restricciones o catálogos: el modelo `User` tiene los campos `id`, `username`, `firstName`, `lastName`, `email`, `password`, `phone`, `userStatus`
- Schemas esperados:
  - `user-response.json` — schema del objeto `User` retornado por `GET /user/{username}`
  - `api-response.json` — schema de la respuesta genérica `{ code, type, message }` retornada por `POST`, `PUT` y `DELETE`

## Criterios de automatización

1. El dominio debe tener su propio runner.
2. Runner y features deben vivir en la misma carpeta de dominio: `src/test/java/template/user/`.
3. Los datos deben quedar en `src/test/resources/data/user/`.
4. Los schemas deben quedar en `src/test/resources/schemas/user/`.
5. Deben usarse los tags del template (`@smoke`, `@regression`).
6. El scaffold Karate ya está pre-built en el repo.

## Fuera de alcance

- Flujos negativos (usuario no encontrado, datos inválidos, duplicados)
- Operaciones de `POST /user/createWithArray` y `POST /user/createWithList`
- Login (`GET /user/login`) y logout (`GET /user/logout`) como flujos independientes
- Dominios `pet` y `store`
