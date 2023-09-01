package domain.Profesion

class Ladron(_habilidad_manual : Int) extends Profesion {

  var habilidad_manual : Int = _habilidad_manual

  def subir_de_nivel() : Unit = this.habilidad_manual + 3
}
