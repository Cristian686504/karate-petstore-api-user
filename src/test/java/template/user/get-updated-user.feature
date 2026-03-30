@smoke @regression
Feature: Buscar usuario actualizado

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def userSchema = read('classpath:schemas/user/user-response.json')
    * def createData = read('classpath:data/user/create-user.json')
    * def updateData = read('classpath:data/user/update-user.json')

  Scenario: Verificar datos actualizados via GET /user/{username}
    Given path paths.getUser + createData.username
    When method get
    Then status 200
    And match response == userSchema
    And match response.firstName == updateData.firstName
    And match response.email == updateData.email
