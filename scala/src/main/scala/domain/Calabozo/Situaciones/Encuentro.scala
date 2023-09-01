package domain.Calabozo.Situaciones

import domain.{Grupo, Heroe}

class Encuentro(_heroe : Heroe) {

  var heroe : Heroe = _heroe

  def ejecutar(grupo: Grupo) : Unit = {

    val grupoAux: Grupo = grupo
      grupoAux.agregarHeroe(this.heroe)

    if(this.heroe.cumpleCriterio(grupo) && grupoAux.getLider.cumpleCriterio(grupoAux)) {
      grupo.agregarHeroe(this.heroe)
    } else {
      grupo.pelearCon(this.heroe)
    }
  }
}
