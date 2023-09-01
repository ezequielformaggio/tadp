require_relative 'testing_dsl'
require_relative 'modelo_datos'

puts "esto no deberia entender deberia: #{Object.new.respond_to? :deberia}"
puts "un modulo no deberia entendender mockear #{Persona.respond_to? :mockear}"
puts "un modulo no deberia entendender mockear #{Persona.new(30).respond_to? :mockear}"
