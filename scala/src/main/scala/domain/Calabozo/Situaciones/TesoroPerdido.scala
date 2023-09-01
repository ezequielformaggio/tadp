package domain.Calabozo.Situaciones

import domain.CofreComun.Item
import domain.Grupo

class TesoroPerdido(_item : Item) {

  var item : Item = _item

  def recolectar(grupo : Grupo) : Unit = grupo.agregarItem(this.item)
}
