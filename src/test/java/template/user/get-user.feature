@ignore
Feature: Buscar usuario

  Scenario: Buscar usuario via GET /user/{username}
    Given url baseUrl
    And header api_key = apiKey
    And path paths.getUser + username
    When method get
    Then status 200
    * def userSchema = read('classpath:schemas/user/user-response.json')
    And match response == userSchema
