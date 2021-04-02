class Magic
    attr_accessor :name, :element, :damage, :target, :effect, :triggered
    def initialize(name,element,damage,effect = nil,target = nil)
        @name = name
        @element = element
        @damage = damage
        @target = target
        @effect = effect
        @triggered = false
    end
end