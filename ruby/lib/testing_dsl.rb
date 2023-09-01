require 'colorize'



module Aserciones


  def self.included(modulo_agregado)

    Object.define_method(:deberia) do |esperado|

      begin
        verificador = Aserciones.get_proc esperado

        rtdo = verificador.call self
        paso_el_test = rtdo[:result]
        return TpSuite.class_variable_get(:@@fallados) << rtdo if !paso_el_test
        raise TpError unless paso_el_test

        rescue NoMethodError=>e
          return TpSuite.class_variable_get(:@@explotados) << resultado(e.message,nil, nil)
        rescue
        return TpSuite.class_variable_get(:@@explotados) << rtdo

      end
      TpSuite.class_variable_get(:@@pasados) << rtdo

    end
    def self.get_proc(esperado)
      if esperado.is_a? ResultadoSpiable
        proc = esperado.get_proc
      else
        proc = esperado
      end
      proc
    end
  end



  private def resultado (mensaje,obtenido,result,esperado=true )
    {mensaje:mensaje,evaluado_con:self,obtenido: obtenido,esperado:esperado,result: result}
  end

  def ser (objeto_esperado)
    return igual_a objeto_esperado unless objeto_esperado.is_a? Proc
    objeto_esperado
  end

  def igual_a(valor_esperado)
    proc{|valor_obtenido| resultado(__method__ ,valor_obtenido,valor_esperado == valor_obtenido, valor_esperado)}
  end

  def mayor_a(valor_esperado)
    proc{|valor_obtenido| resultado(__method__,valor_obtenido ,valor_obtenido >valor_esperado  , valor_esperado)}
  end

  def menor_a(valor_esperado)
    proc{|valor_obtenido| resultado(__method__,valor_obtenido ,(valor_obtenido <valor_esperado) , valor_esperado)}
  end

  def uno_de_estos(*elementos)
    proc {|valor_obtenido| resultado(__method__,valor_obtenido , (elementos.flatten(1).include? (valor_obtenido)))}
  end

  private def azucares
    {
      ser_: proc{|un_sym| Ser.new un_sym},
      tener_: proc{|un_sym| Tener.new un_sym}
    }
  end



  private def es_azucar?(symbol)
    azucares.keys.include? (symbol.prefijo.to_sym)
  end

  def entender(symbol)
    proc {|valor_obtenido| resultado(__method__,valor_obtenido , (valor_obtenido .respond_to? (symbol))) }
  end

  def explotar_con un_error
    proc do |block|
      exploto = false

      begin
        block.call
        rescue un_error
        exploto = true
        rescue
      end
      resultado(__method__.to_s + un_error.to_s,un_error,exploto)
    end
  end

  def en &block
    block
  end

  def method_missing(symbol, *args, &block)
    if  es_azucar? symbol
      azucar = azucares[symbol.prefijo.to_sym].call(symbol)
      ser  azucar.verificador_para(*args)
    else if symbol.es_mock?
      super.singleton_class.send(symbol, *args, &block)
         else
        super
         end
    end
  end

  def respond_to_missing?(symbol, priv = false)
    es_azucar? symbol ||
                 (symbol.es_mock? and super.singleton_class.respond_to?(symbol,priv)) ||
                 super
  end


  def haber_recibido(simbolo)
      ResultadoSpiable.new(simbolo)
  end

  def espiar(objeto)
    Spiable.new(objeto)
  end

end


class Azucar
  include Aserciones
  attr_accessor :symbol
  private_class_method :new
  def initialize(symbol)
    @symbol = symbol
  end

  def verificador_para (*args)
    proc{|objeto_obtenido| evaluador.call(objeto_obtenido,args.first) }
  end
end

class  Tener<Azucar
  public_class_method :new
  def mensaje
    symbol.sufijo_atributo.to_sym
  end

  def evaluador
    proc{ |obj,evaluacion|
      valor =  obj.send(:instance_variable_get,  mensaje)
      evaluacion = igual_a(evaluacion)  unless evaluacion.is_a? Proc
      evaluacion.call(valor) }
  end
end

class  Ser<Azucar
  public_class_method :new
  def mensaje
    symbol.sufijo_booleano.to_sym
  end

  def evaluador
    proc{ |obj| obtenido = obj.send(mensaje)
    self.send(:resultado,self.class.to_s + mensaje.to_s,mensaje,obtenido )
}
  end

end

class ResultadoSpiable

  def initialize(simbolo)
    @simbolo = simbolo
  end
  def veces(cantidad)
    proc{|spiado|
      resultado("#{spiado}haber_recibido #{@simbolo}",
                spiado.veces(@simbolo),
                spiado.veces(@simbolo) == cantidad, cantidad)
}
  end

  def con_argumentos(*args)
    proc{|spiado|
      resultado("#{spiado}haber_recibido #{@simbolo}",
                spiado.con_argumentos(args, @simbolo),
                spiado.con_argumentos(args, @simbolo) == true)
    }
  end
  def get_proc
    proc{|spiado|
          resultado("#{spiado}haber_recibido #{@simbolo}",
              spiado.recibidos,
              spiado.recibidos.any? {|e| e[:mensaje].eql? @simbolo})
    }
  end

end


class Spiable
  attr_accessor :contador, :recibidos
  def initialize(objeto)
    @objeto = objeto
    @metodos = objeto.class.instance_methods(false).reject{|m|m.es_setter?}
    @@contador =[]
    @recibidos = []
    @metodos_originales = []
    @objeto.instance_variable_set(:@espiador, self)
    redefinir_metodos
  end

  def recibidos
    @recibidos
  end

  def redefinir_metodos
    @metodos.each{|e| @metodos_originales << @objeto.method(e)}

    espiados = self.recibidos
    @metodos_originales.each do
    |e| @objeto.define_singleton_method(e.name.to_sym)do |*args|
      espiados << {mensaje: e.name.to_sym, argumentos: args}
      e.call
    end
    end
  end


  def method_missing(symbol, *args)
    @objeto.send(symbol, *args)
  end

  def veces(mensaje)
    @recibidos.count{ |e| e[:mensaje] == mensaje}
  end

  def con_argumentos(args,simbolo)
    @recibidos.any?{|e| e[:argumentos] == args}
  end
end


class TpSuite
  attr_accessor :testOK, :testFail, :pasados, :fallados, :explociones

  @@pasados = []
  @@fallados = []
  @@explotados = []
  @testOk = []
  @testFail = []
  @testExpltados = []

  def self.demockear
    clases = Object.constants.map{|e| Object.const_get(e)}.filter{|e| e.respond_to? :new and e.class_variable_defined? :@@metodo_mockeado}
    if clases != nil
      clases.each {|e|e.desmockear}
    end
  end

  def self.limpiarListas
    @@pasados = []
    @@fallados = []
    @@explotados = []
  end

  def self.obtener_resultado(test)

    if @@fallados.empty? and @@explotados.empty?
      @testOk << test
    elsif @@explotados.empty?
      @testFail << test
    else
      @testExpltados << test
    end
  end

  def self.ejecutar_suite suite,simbolo

    begin
      resultado = suite.new.send(simbolo)
    rescue => e
      @@explotados << "Falló el test: #{simbolo.to_s}. Motivo:  #{e}. Pila: #{e.backtrace}"
      resultado = false
    end
    resultado
  end

  def self.testear_suite(suite, &bloque)
    Object.include Aserciones
    Module.include Mocking

    ((suite.instance_methods false).filter { |metodo| bloque.call(metodo) }).each do |simbolo|
      resultado = self.ejecutar_suite suite,simbolo
      TpSuite.obtener_resultado(Test.new(simbolo, resultado, @@pasados, @@fallados, @@explotados))
      TpSuite.demockear
      TpSuite.limpiarListas
    end
  end

  def self.es_test? sym
    sym.es_test? if sym.is_a? Symbol
  end

  def self.testear(*args)
    require_relative 'extensiones'
    if args.length >= 1
      if args.length == 1
        self.testear_suite(args.first) { |simbolo| es_test? simbolo }
      else
        testear_suite(args.first) do |simbolo|
        end
      end
    else
      testear_todo { |simbolo| simbolo.es_test?}
    end
    self.mostrar_resultados
  end

  def self.suites
    Object.constants.map { |s| Object.const_get(s) }
          .filter { |c| c.respond_to? :new  and
            c.instance_methods.any? { |m| m.es_test? } }
  end

  def self.testear_todo(&block)
    self.suites.each { |s| testear_suite s, &block }
  end

  def self.mostrar_resultados
    puts "PASSED: #{@testOk.size} ".green
    @testOk.each { |test| test.mostrar_test }
    puts "FAILED: #{@testFail.size}".red
    @testFail.each {|test| test.mostrar_test }
    puts "EXPLOITED: #{@testExpltados.size}".blue
    @testExpltados.each{|test| test.mostrar_test}
  end


end

class Test
  attr_accessor :simbolo, :resultado, :pasados, :fallados, :explotados



  def initialize(simbolo, resultado, pasados, fallados, explotados)
    @simbolo = simbolo
    @resultado = resultado
    @pasados = pasados
    @fallados = fallados
    @explotados = explotados
  end

  def mostrar_test
    puts "#{@simbolo} "
    @pasados.each{|e| mostrar_detalle e } if !@pasados.empty?
    @fallados.each{|e| mostrar_detalle e } if !@fallados.empty?
    @explotados.each{|e| mostrar_detalle e } if !@explotados.empty?
  end
  def mostrar_detalle(testeable)
    puts testeable
  end

end


module Mocking

  def mockear (simbolo, &bloque)
    class_variable_set(:@@metodo_mockeado,[sym: simbolo, cuerpo: self.new.method(simbolo)])
    TpSuite.class_variable_set(:@@mockeo, true)
    define_method(simbolo) do
      bloque.call
    end
  end
  def desmockear

    mockeado = class_variable_get(:@@metodo_mockeado)
    define_method(mockeado[0][:sym]) do
      mockeado[0][:cuerpo].call
    end
  end
end