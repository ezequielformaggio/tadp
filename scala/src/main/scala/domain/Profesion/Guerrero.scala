package domain.Profesion

import domain.Heroe

class Guerrero extends Profesion {
  def setFuerza(heroe : Heroe): Unit = {
    heroe.setFuerza(heroe.getNivel * 20 / 100 + heroe.getFuerza)
  }
}
