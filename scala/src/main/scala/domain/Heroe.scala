package domain

import domain.Criterios.Criterio
import domain.Exception.SaludNegativaException
import domain.Profesion.Profesion

class Heroe(_fuerza : Int, _velocidad : Int, var _nivel : Int,
            var _salud : Int, _profesion : Profesion,
            _criterio : Criterio) {

  var fuerza: Int = _fuerza // deberia chequearse si es guerrero para agregarle 20% mas pero depende de la implementacion
  var velocidad : Int = _velocidad
  var nivel : Int = _nivel
  var vivo : Boolean = true
  var profesion : Profesion = _profesion
  var salud : Int = chequearSalud(_salud)
  //var grupo : Option[Grupo] = None TODO chequear doble referencia
  var criterio : Criterio = _criterio

  def recibirDanio(danio: Int): Unit = {
    if (this.salud - danio > 0) {
      this.salud -= danio
    } else {
      this.morir()
    }
  }
  def morir() : Unit = {
    this.vivo = false
    this.salud = 0
    //this.grupo.foreach(g => g.murioHeroe(this))
  }
  def setGrupo(_grupo : Grupo) : Unit = ??? //this.grupo.(_grupo)// como metemos al grupo ???
  def getVelocidad : Int = this.velocidad
  def getNivel: Int = this.nivel
  def getFuerza: Int = this.fuerza
  def setFuerza(valor : Int): Unit = this.fuerza = valor
  def chequearSalud(valor : Int): Int = {
    if(valor < 0) {
      throw new SaludNegativaException
    }
    valor
  }
  def cumpleCriterio(grupo: Grupo) : Boolean = { this.criterio.seCumple(grupo)}
  def subirNivel(valor : Int) : Unit = { this.nivel += valor}
}
