package domain.Criterios

import domain.Grupo

class Introvertido extends Criterio {
  def seCumple(grupo: Grupo) : Boolean = {
    grupo.getHeroes.size <= 3
  }
}
