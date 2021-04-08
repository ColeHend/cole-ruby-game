require_relative "events/hpbar.rb"
require_relative "player_control.rb"
class Player
    attr_accessor :x, :y, :w, :h, :showPlayer, :player, :facing, :activateType
    attr_reader :sprite
    
    def initialize()
        #@sprite = Gosu::Image.load_tiles("data/img/greenCoat.bmp", 32, 48)
        @player = $scene_manager.register_object("player",:player,3*32,3*32,32,48,4,4)
        @showPlayer = true
        
        @playerControl = PlayerControl.new()
        @x = (@player.x )
        @y = (@player.y )
        @w = @player.w
        @h = @player.h
        @activateType = "none"
        @z = 5
        @facing = @playerControl.facing
        @party = $scene_manager.feature["party"]
        @hpbar = HPbar.new(@player.x,@player.y,@party.party[0].hp,@party.party[0].currentHP)
    end
    

    def update(blas="hi")
        @player = $scene_manager.object["player"]
        @facing = @playerControl.facing
        @x = (@player.x)
        @y = (@player.y)
        @hpbar.update(@player.x,@player.y,@party.party[0].hp,@party.party[0].currentHP)
        @playerControl.update
        
    end
    
    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap.map
        @player = $scene_manager.object["player"]
        if @showPlayer == true
            @player.draw()
            @hpbar.draw
            @playerControl.draw
        end
    end
end
