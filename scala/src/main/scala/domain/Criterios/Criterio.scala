package domain.Criterios

import domain.Grupo

abstract class Criterio {
  def seCumple(grupo: Grupo) : Boolean
}
