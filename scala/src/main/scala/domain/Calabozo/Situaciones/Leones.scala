package domain.Calabozo.Situaciones

import domain.Grupo

class Leones {
  def ejecutar(grupo: Grupo) : Unit = {
    grupo.getHeroes.minBy(h => h.getVelocidad).morir()
  }
}
