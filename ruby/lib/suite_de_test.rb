require_relative 'modelo_datos'

class Suite

  def testear_que_8_es_igual_a_8
    8.deberia ser 8
    7.deberia ser 7
  end

  def testear_que_edad_de_persona_es_menor_a_24
    Persona.new(25).edad.deberia ser menor_a 24
  end

  def testear_que_9_es_mayor_que_5_explota
    9.deberia ser mayor_a 5
    10.deberia ser 10
    7 / 0
  end

  def testear_que_explota_con_zero_division_error
    en { 7 / 0 }.deberia explotar_con ZeroDivisionError # pasa
  end
end

class Suite2
  require_relative 'testing_dsl'
  attr_accessor :leandro

  def self.Prueba
    Object.include Aserciones
    results.clear
    true.deberia ser true
  end

  def testear_que_puede_assertear_que_true_es_igual_true
    true.deberia ser true
  end

  def testear_que_falla_al_assertear_que_2_mas_2_es_menor_que_1_falla
    (2 + 2).deberia ser menor_a 1
  end

  def testear_que_puede_assertear_que_2_mas_2_es_mayor_que_3
    (2 + 2).deberia ser mayor_a(3)
  end

  def testear_que_7_es_7
    7.deberia ser 7 # pasa
  end

  def testear_que_falla_cuando_true_no_es_igual_a_false
    true.deberia ser false # falla, obvio
  end

  def teastear_que_edad_de_leandro_es_25
    leandro = Persona.new(23)
    leandro.edad.deberia ser 25 #falla (lean tiene 22)
  end

  def esto_no_es_un_test_no_deberia_hacer_nada
    puts " NO ES TEST"
    true
  end

  define_method(:testear_que_el_test_pasa_si_el_objeto_es_mayor_al_parametro) do
    leandro = Persona.new(23)
    leandro.edad.deberia ser mayor_a 20
  end

  def testear_que_el_test_pasa_si_el_objeto_es_menor_al_parametro
    leandro = Persona.new(23)
    leandro.edad.deberia ser menor_a 25
  end

  def testear_que_el_test_pasa_el_objeto_esta_en_la_lista_recibida_por_parametro
    leandro = Persona.new(23)
    leandro.edad.deberia ser uno_de_estos [7, 23, "hola"]
  end

  def testear_que_puede_escribirse_usando_varargs_en_lugar_de_un_array
    leandro = Persona.new(23)
    leandro.edad.deberia ser uno_de_estos 7, 23, "hola"
  end

  def testear_que_leandro_entiende_viejo?
    leandro = Persona.new(23)
    leandro.deberia entender :viejo?
  end

  def testear_que_leandro_entiende_class
    leandro = Persona.new(23)
    leandro.deberia entender :class # pasa: este mensaje se hereda de Object
  end

  def testear_que_leandro_entiende_nombre
    leandro = Persona.new(23)
    leandro.deberia entender :nombre # falla: leandro no entiende el mensaje
  end

  def testear_que_explota_con_zero_division_error
    en { 7 / 0 }.deberia explotar_con ZeroDivisionError # pasa
  end

  def testear_que_explota_con_NoMethodError
    en { leandro.nombre }.deberia explotar_con NoMethodError
  end

  # pasa

  def testear_que_explota_con_Error
    en { leandro.nombre }.deberia explotar_con NoMethodError # pasa: NoMethodError <
  end

  def testear_que_NO_explota_con_NoMethodError
    en { leandro.viejo? }.deberia explotar_con NoMethodError # falla: No tira
  end

  def testear_que_NO_explota_con_NoMethodError
    en { 7 / 0 }.deberia explotar_con NoMethodError # falla: Tira otro error
  end

end

class Mockeo ## cabe destacar que en el tp no hay ningun new y que dice que las clases deben entender .mockear, por eso se define el metodo para que lo entiendan las clases y no sus intanccias
  #pero tambien esta definido como metodo de instancia todas_las_personas. Se opta por la solucion implementada pero lo mas simple seria que las instancias de Personahome entiendan el mockeo
  # ej: instancia = PersonaHome.new.mockear(:todas_las_pesonas), de esa manera se podria redefinir el metodo en la singleton_class y no afectaria al resto de test que pidan una nueva instancia de PersonaHome

  def testear_que_mockeo_cambia_un_metodo_
    PersonaHome.mockear(:todas_las_personas) do
      25
    end
    #   p PersonaHome.class_variable_get(:@@metodo_mockeado)
    PersonaHome.new.todas_las_personas.deberia ser 25
  end

  def testear_que_personas_viejas_trae_100
    nico = Persona.new(30)
    axel = Persona.new(30)
    lean = Persona.new(22)

    PersonaHome.mockear(:todas_las_personas) do
      [nico, axel, lean]
    end
    PersonaHome.new.personas_viejas.deberia ser [nico, axel]
  end
end

class Spies

  # def testear_que_se_use_la_edad
  #   pato = Persona.new(23)
  #   pato = espiar(pato)
  #   pato.viejo?
  #     pato.deberia haber_recibido(:edad)
  #
  #    pato.deberia haber_recibido(:edad).veces 1
  # end

  def testear_que_uno_no_espiado_no_responde_a_haber_recibido_explota
    leo = Persona.new(58)
    leo.viejo?
    leo.deberia haber_recibido(:edad)

  end

  def testear_que_pato_recibio_viejo_con_argumentos_falla
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?
    pato.deberia haber_recibido(:viejo?).con_argumentos(19, "hola")
  end

  def testear_que_pato_recibio_viejo_sin_args
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?
    pato.deberia haber_recibido(:viejo?).con_argumentos()
  end

  # def pato
  #   pato = Persona.new(23)
  #   pato = espiar(pato)
  #   pato.viejo?
  #   pato
  # end
  #
  # def  testear_que_pato_recibio_edad_1_vez
  #   pato.deberia haber_recibido(:edad).veces(1)
  # end
  #   # pasa: edad se recibió exactamente 1 vez.
  #
  # def testear_que_pato_no_recibio_edad_5_veces
  #       pato.deberia haber_recibido(:edad).veces(5)
  #   # falla: edad sólo se recibió una vez.
  # end

end