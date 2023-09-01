package domain.Calabozo

import domain.Calabozo.Puerta.Puerta
import domain.Grupo

class Calabozo(_puertaPrincipal : Puerta) {
  var puertaPrincipal : Puerta = _puertaPrincipal

  def mejorGrupoParaReocrrer(grupos : Set[Grupo]): Grupo = ???
}
