@smoke @regression
Feature: Buscar usuario creado

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def userSchema = read('classpath:schemas/user/user-response.json')
    * def createData = read('classpath:data/user/create-user.json')

  Scenario: Buscar usuario via GET /user/{username}
    Given path paths.getUser + createData.username
    When method get
    Then status 200
    And match response == userSchema
    And match response.username == createData.username
    And match response.firstName == createData.firstName
    And match response.lastName == createData.lastName
    And match response.email == createData.email
