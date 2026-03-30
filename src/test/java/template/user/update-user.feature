@ignore
Feature: Actualizar usuario

  Scenario: Actualizar usuario via PUT /user/{username}
    Given url baseUrl
    And header api_key = apiKey
    And path paths.updateUser + username
    * def updateData = read('classpath:data/user/update-user.json')
    * updateData.id = userId
    And request updateData
    When method put
    Then status 200
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    And match response == apiSchema
