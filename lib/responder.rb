class Responder
  @registered_responders = {}
  
  class << self
    attr_reader :registered_responders
    private :new
  end

  def self.define(pattern, &block)
    p = new
    p.instance_eval(&block)
    Responder.registered_responders[pattern] = p
  end
end