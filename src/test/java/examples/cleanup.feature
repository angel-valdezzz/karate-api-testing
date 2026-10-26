@ignore
Feature: Remove only the user created by this scenario
  Scenario:
    Given url baseUrl
    And path 'users', id
    And header X-API-Key = apiKey
    When method delete
    Then assert responseStatus == 204 || responseStatus == 404
