package domain.Calabozo.Puerta

import domain.Grupo

class PuertaCerrada extends Puerta {

  def puedeAbrirla(grupo : Grupo): Boolean = {
    grupo.tieneItem(llave) || grupo.tieneItem(ganzuas) || grupo.tieneLadronNivel(10)
  } // aca un switch va de cabeza
}
