@smoke @regression
Feature: CRUD completo de usuario en Petstore API

  Background:
    * def createData = read('classpath:data/user/create-user.json')
    * def updateData = read('classpath:data/user/update-user.json')

  Scenario: Flujo completo CRUD de usuario

    # Cleanup: eliminar usuario si existe de ejecuciones anteriores
    Given url baseUrl
    And header api_key = apiKey
    And path paths.deleteUser + createData.username
    When method delete
    * def ignore = responseStatus

    # 1. Crear usuario
    * def createResult = call read('create-user.feature')

    # 2. Buscar el usuario creado
    * def getResult = call read('get-user.feature') { username: '#(createData.username)' }
    * match getResult.response.username == createData.username
    * match getResult.response.firstName == createData.firstName
    * match getResult.response.lastName == createData.lastName
    * match getResult.response.email == createData.email

    # 3. Actualizar nombre y correo del usuario
    * def userId = getResult.response.id
    * def updateResult = call read('update-user.feature') { username: '#(createData.username)', userId: '#(userId)' }

    # 4. Buscar el usuario actualizado
    * def getUpdatedResult = call read('get-updated-user.feature') { username: '#(createData.username)', expectedFirstName: 'KarateUpdated', expectedEmail: 'karate_updated@test.com' }

    # 5. Eliminar usuario
    * def deleteResult = call read('delete-user.feature') { username: '#(createData.username)' }
