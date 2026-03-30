@ignore
Feature: Eliminar usuario

  Scenario: Eliminar usuario via DELETE /user/{username}
    Given url baseUrl
    And header api_key = apiKey
    And path paths.deleteUser + username
    When method delete
    Then status 200
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    And match response == apiSchema
