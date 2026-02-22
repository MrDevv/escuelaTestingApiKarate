@regresion
Feature: Automatizar el backend de petstore

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/jsonData/crearMascota.json')

  @TEST-1 @happypath @crearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store
    Given path 'pet'
    And request jsonCrearMascota
    And print jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 1
    And match response.name == 'nombre test'
    And print response
    * def idPet = response.id
    And print idPet

  @TEST-2 @happypath
  Scenario Outline: Verificar la obtencion de mascotas por estado
    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And print response

    Examples:
      | estado    |
      | available |
      | pending   |
      | sold      |

  @TEST-3 @happypath
  Scenario: Verificar la actualizacion de la mascota previamente registrada
    Given path 'pet'
    And set jsonCrearMascota.id = 1
    And set jsonCrearMascota.name = 'mascota actualizada'
    And request jsonCrearMascota
    When method put
    Then status 200
    And print response


  @TEST-4
  Scenario: Verificar la busqueda de una mascota por su id
    * def petId = 1

    Given path 'pet', petId
    When method get
    Then status 200
    And match response.id == petId
    And print response

#    Examples:
#      | petId |
#      | 1     |
#      | 2     |
#      | 3     |

  @TEST-5
  Scenario: Subir una imagen para una mascota existente
    * def petId = 4

    Given path 'pet', petId, 'uploadImage'
    And multipart file file = { read: 'classpath:examples/imagenes/fondo.jpg', filename: 'fondo.jpg', contentType: 'image/jpg' }
    And multipart field additionalMetadata = 'Foto de perfil actualizada'
    When method post
    Then status 200
    And print response
    And match response.message contains 'fondo.jpg'


#    llamar a otro caso de prueba para usar despues
  @TEST-6
  Scenario: Verificar la busqueda de una mascota por su id
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')

    Given path 'pet', idMascota.idPet
    When method get
    Then status 200
    And match response.id == idMascota.idPet
    And print response
