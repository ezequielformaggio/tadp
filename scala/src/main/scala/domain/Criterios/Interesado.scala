package domain.Criterios

import domain.CofreComun.Item
import domain.Grupo

class Interesado(_item: Item) extends Criterio {

  var item : Item = _item

  def seCumple(grupo: Grupo) : Boolean = {
    grupo.tieneItem(this.item)
  }
}
