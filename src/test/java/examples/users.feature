Feature: Demo Users API business contract
  Background:
    * url baseUrl
    * def createdIds = []
    * def email = java.util.UUID.randomUUID().toString() + '@example.com'

  Scenario: CRUD and lifecycle with strict response checks
    Given path 'users'
    And request { name: 'Automation', email: '#(email)', role: 'sales', active: true }
    When method post
    Then status 201
    And match response contains { id: '#uuid', name: 'Automation', email: '#(email)', role: 'sales', active: true }
    * def id = response.id
    * eval createdIds.push(id)
    And match header Location == '/users/' + id
    Given path 'users', id
    When method get
    Then status 200
    And match response.id == id
    Given path 'users', id, 'activate'
    When method post
    Then status 409
    Given path 'users', id, 'deactivate'
    When method post
    Then status 200
    And match response.active == false
    Given path 'users', id
    And request { name: 'Replaced', email: '#(email)' }
    When method put
    Then status 200
    And match response contains { name: 'Replaced', role: 'support', active: true }
    Given path 'users', id
    And request { active: false }
    When method patch
    Then status 200
    And match response.active == false
    Given path 'users', id
    When method delete
    Then status 204
    Given path 'users', id
    When method get
    Then status 404

  Scenario: Duplicate email is rejected
    Given path 'users'
    And request { name: 'Original', email: '#(email)' }
    When method post
    Then status 201
    * eval createdIds.push(response.id)
    Given path 'users'
    And request { name: 'Duplicate', email: '#(email)' }
    When method post
    Then status 409

  Scenario Outline: Invalid payloads return validation errors
    Given path 'users'
    And request <payload>
    When method post
    Then status 422
    Examples:
      | payload |
      | { name: '', email: 'invalid' } |
      | { name: 'A', email: 'a@example.com', role: 'owner' } |
      | { name: 'A', email: 'a@example.com', unknown: true } |

  Scenario: Invalid credentials and pagination
    Given path 'users'
    * configure headers = { 'X-API-Key': 'invalid' }
    When method get
    Then status 401
    Given path 'users'
    * configure headers = { 'X-API-Key': '#(apiKey)' }
    And param limit = 0
    When method get
    Then status 422
