package domain.Criterios

import domain.Grupo

class Bigote extends Criterio {
  def seCumple(grupo: Grupo) : Boolean = {
    grupo.getHeroes.filter(h => h.esLAdron).isEmpty
  }
}
