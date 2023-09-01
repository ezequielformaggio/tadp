class Persona
  attr_accessor :edad, :nombre

  def initialize(edad)
    @edad = edad
  end

  def viejo?
    self.edad > 29
  end

  def envejecer(anios)
    self.edad += anios
  end

end
class PersonaHome
  def todas_las_personas
    (20..35).step(5).to_a.map{|edad| Persona.new edad}
  end

  def personas_viejas
    self.todas_las_personas.filter { |p| p.viejo? }
  end
end
