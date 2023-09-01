package domain.CofreComun

class CofreComun(_items : Set[Item]) {

  var items : Set[Item] = _items

  def tiene(_item: Item) : Boolean = { this.items.contains(_item)}
  def agregar(item: Item): Unit = this.items ++ item
  // ojo porque set no soporta repetidos, hay que ver si tratamos a los items como enums o como clases
}
