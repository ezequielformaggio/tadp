package domain.Calabozo.Puerta

import domain.Grupo

class PuertaEscondida extends Puerta {

  def puedeAbrirla(grupo : Grupo): Boolean = {
    grupo.tieneMagoCapaz(vislumbrar) || grupo.tieneLadronNivel(6)
  }
}
