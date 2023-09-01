package domain.Calabozo.Situaciones

import domain.Grupo

class Dardos {
  def ejecutar(grupo: Grupo) : Unit = grupo.getHeroes.foreach(h => h.recibirDanio(10))
}
