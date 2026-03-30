@smoke @regression
Feature: Actualizar usuario

  Background:
    * url baseUrl
    * header api_key = apiKey
    * def apiSchema = read('classpath:schemas/user/api-response.json')
    * def createData = read('classpath:data/user/create-user.json')
    * def updateData = read('classpath:data/user/update-user.json')

  Scenario: Actualizar nombre y correo via PUT /user/{username}
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
    And match response == apiSchema

    Given path paths.deleteUser + createData.username
    When method delete
