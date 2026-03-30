@smoke @regression
Feature: Buscar usuario actualizado

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def userSchema = read('classpath:schemas/user/user-response.json')
    * def createData = read('classpath:data/user/create-user.json')
    * def updateData = read('classpath:data/user/update-user.json')

  Scenario: Verificar datos actualizados via GET /user/{username}
    * call read('create-user.feature')

    Given path paths.getUser + createData.username
    When method get
    Then status 200
    * def userId = response.id
    * updateData.id = userId

    Given path paths.updateUser + createData.username
    And request updateData
    When method put
    Then status 200

    Given path paths.getUser + createData.username
    When method get
    Then status 200
    And match response == userSchema
    And match response.firstName == updateData.firstName
    And match response.email == updateData.email

    Given path paths.deleteUser + createData.username
    When method delete
