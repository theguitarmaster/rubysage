class Action
  @registered_actions = {}
  
  class << self
    attr_reader :registered_actions
    private :new
  end

  def self.define(name, &block)
    p = new
    p.instance_eval(&block)
    Action.registered_actions[name] = p
  end
end