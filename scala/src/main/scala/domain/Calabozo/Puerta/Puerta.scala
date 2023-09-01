package domain.Calabozo.Puerta

import domain.Grupo

abstract class Puerta() {
  // var habitacionSiguiente : Habitacion = _habitacionSiguiente
  var visitada : Boolean = false

  def puedeAbrirla(grupo : Grupo): Boolean

  def entrar() = ???
}
