require_relative "character_base.rb"
class EnemyCharacter < CharacterBase
    def initialize(name,hp)
        @name,@hp = name,hp
    end
end