package domain.Profesion

class Mago(_hechizos : Set[Hechizo]) extends Profesion {
  var hechizos : Set[Hechizo] = _hechizos

  def conoceHechizo(_hechizo : Hechizo) : Boolean = this.hechizos.contains(_hechizo)
}
