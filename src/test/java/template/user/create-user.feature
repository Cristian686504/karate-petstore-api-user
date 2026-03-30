@smoke @regression
Feature: Crear usuario

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    * def createData = read('classpath:data/user/create-user.json')

  Scenario: Crear usuario via POST /user
    Given path paths.createUser
    And request createData
    When method post
    Then status 200
    And match response == apiSchema
