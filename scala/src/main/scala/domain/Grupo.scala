package domain

import domain.Calabozo.Habitacion
import domain.Calabozo.Puerta.Puerta
import domain.CofreComun.{CofreComun, Item}
import domain.Profesion.Hechizo
import scala.collection.convert.ImplicitConversions.`collection asJava`

class Grupo(_heroes : List[Heroe], _cofre : CofreComun) {

  var heroes : List[Heroe] = inicializarGrupo(_heroes)
  var cofre : CofreComun = _cofre
  var habitacionActual : Option[Habitacion] = None
  var habitacionesVisitadas : Option[Habitacion] = None
  var habitacionesPorVisitar : Option[Habitacion] = None

  def tieneLadronNivel(nivel : Int) : Boolean = { this.heroes.filter(/*h => h.es_ladron nivel mayor a...*/) }
  def tieneMagoCapaz(hechizo : Hechizo): Boolean = {
    this.heroes.filter(/*h => h.es_mago conoceHechizo(...)*/)}
  def tieneItem(item : Item): Boolean = cofre.tiene(item)
  def inicializarGrupo(heroes: List[Heroe]) : List[Heroe] = {
    heroes.foreach(heroe => heroe.setGrupo(this))
    heroes
  }
  def getLider : Heroe = this.heroes.head
  def getHeroes : List[Heroe] = this.heroes
  def getFuerzaGrupal: Int = {
    this.heroes.map(h => h.getFuerza).sum
  }
  def agregarItem(item : Item) : Unit = this.cofre.agregar(item)
  def agregarHeroe(heroe: Heroe) : Unit = {
    this.heroes.add(heroe)
    heroe.setGrupo(this)
  }
  def pasarASiguienteHabitacion() = ???
  def pelearCon(heroe : Heroe) : Unit = {
    if(this.getFuerzaGrupal > heroe.getFuerza) {
      this.heroes.foreach(h => h.subirNivel(1))
    } else {
      this.heroes.foreach(h => h.recibirDanio(heroe.getFuerza / this.heroes.size))
    }
  }
  /*def murioHeroe(heroe: Heroe) : Unit = {
    this.heroes.remove(heroe)
    this.heroesMuertos.map(heroes => heroes.add(heroe))
  }*/
  def puedeAbrir(puerta : Puerta) : Boolean = {
    puerta.puedeAbrirla(this)
  }
}
