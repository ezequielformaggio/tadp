
module String_extension
  String.include self
  def prefijo_test
    "testear_que_"
  end

  def prefijo
    if self.include? '_'
     self[0,self.index('_')+1]
    else
      self
    end
  end

  def sufijo
    self.gsub(prefijo, '')
  end

  def es_test?
    self.start_with? prefijo_test
  end

  def nombre_del_test
    nombre = nil
    if es_test?
      nombre =  delete_prefix prefijo_test
    end

    nombre
  end

end

module Symbol_extension
  Symbol.include self

  def prefijo
    self.to_s.prefijo
  end

  def sufijo
    self.to_s.sufijo
  end

  def sufijo_booleano
    self.sufijo + '?'
  end

  def sufijo_atributo
    '@' + self.sufijo
  end

  def empieza_por(elemento)
    if  elemento.instance_of? Array
      elemento.include? self.prefijo
    else
      elemento == self.prefijo
    end
  end

  def es_setter?
    self .to_s.end_with?'='
  end

  def es_test?
    self.to_s.es_test?
  end

  def nombre_del_test
    self.to_s.nombre_de_test
  end
  def es_mock?
    to_s.start_with? "mockear"
  end

end
