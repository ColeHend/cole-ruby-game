class PlayAnimation
    def initialize()
        @drawAnimation = nil
        @off = true
        # V. new effect options
        #(x, y = nil, img = nil, sprite_cols = nil, sprite_rows = nil, interval = 10, indices = nil, lifetime = nil, sound = nil, sound_ext = '.wav', sound_volume = 1)
        @runEffects = Array.new()
        #@slash = 
    end

    def play_animation(animation="slash",x,y,flip)
        @flip = flip or nil
        case animation
            when "slash"
                @runEffects.push(Effect.new(x, y, "Weapon04", 5, 5, 1, [0,1,2,3,4]))
            else 
                puts("FAIL") 
                
        end
    end

    def draw
        if @runEffects.length > 0
            @runEffects.each {|effect|effect.draw(nil,1,1,0xff,0xffffff,nil,@flip)}
        end
    end

    def update
        if @runEffects.length > 0
            @runEffects.each_with_index {|effect,index|
                if effect.dead
                    @runEffects.delete_at(index)
                else
                    effect.update
                end
            }
        end
    end
end