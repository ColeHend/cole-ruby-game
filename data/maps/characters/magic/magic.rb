class Magic
    attr_accessor :name, :range, :object, :stability, :animName, :cooldown, :element, :damage, :target, :effect, :triggered
    def initialize(name,range,object,stability,effect,animName,cooldown)
        @name = name
        @range = range
        @object = object
        @stability = stability
        @animName = animName
        @effect = effect
        @element = element
        @damage = damage
        @target = target
        @cooldown = cooldown
        @triggered = false
    end
end