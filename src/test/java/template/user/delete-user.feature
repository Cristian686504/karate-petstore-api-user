@smoke @regression
Feature: Eliminar usuario

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    * def createData = read('classpath:data/user/create-user.json')

  Scenario: Eliminar usuario via DELETE /user/{username}
    Given path paths.deleteUser + createData.username
    When method delete
    Then status 200
    And match response == apiSchema
