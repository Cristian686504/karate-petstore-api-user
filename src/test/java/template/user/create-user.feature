@ignore
Feature: Crear usuario

  Scenario: Crear usuario via POST /user
    Given url baseUrl
    And header api_key = apiKey
    And path paths.createUser
    * def createData = read('classpath:data/user/create-user.json')
    And request createData
    When method post
    Then status 200
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    And match response == apiSchema
