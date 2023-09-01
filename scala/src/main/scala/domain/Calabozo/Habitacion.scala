package domain.Calabozo

import domain.Calabozo.Puerta.Puerta
import domain.Calabozo.Situaciones.Situacion

class Habitacion(_puertas : Set[Puerta], _situacion : Situacion) {
  var puertas : Set[Puerta] = _puertas
  var situacion: Situacion = _situacion


}
