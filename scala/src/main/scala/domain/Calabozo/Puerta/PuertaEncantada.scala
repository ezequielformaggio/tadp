package domain.Calabozo.Puerta

import domain.Grupo
import domain.Profesion.Hechizo

class PuertaEncantada(_hechizo : Hechizo) extends Puerta {

  var hechizo : Hechizo = _hechizo

  def puedeAbrirla(grupo : Grupo): Boolean = {
    grupo.tieneMagoCapaz(this.hechizo) || grupo.tieneLadronNivel(20)
  }
}
