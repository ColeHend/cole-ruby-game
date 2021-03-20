class CharacterBase
    attr_reader :playerLevel, :exp
    attr_accessor :name, :hp
    def initialize(name,hp)
        @name, @hp = name, hp
        
    end
    
    
end