class PlayAnimation
    def initialize()
        @drawAnimation = nil
        @off = true
        # V. new effect options
        #(x, y = nil, img = nil, sprite_cols = nil, sprite_rows = nil, interval = 10, indices = nil, lifetime = nil, sound = nil, sound_ext = '.wav', sound_volume = 1)
        @runEffects = Array.new()
        #@slash = 
        @animation = nil
    end

    def play_animation(animation="slash",x,y,flip)
        @flip = flip or nil
        @animation = animation
        case @animation
            when "slash"
                @runEffects.push(Effect.new(x, y, "Weapon04", 5, 5, 1, [0,1,2,3,4]))
            when "fire"
                @runEffects.push(Effect.new(x, y, "fire", 5, 2, 1, [0,1,2,3]))
            when "fireExplosion"
                @runEffects.push(Effect.new(x, y, "fireExplosion", 5, 2, 1, [0,1,2,3,4,5]))
            when "earthExplosion"
                @runEffects.push(Effect.new(x, y, "Earth1", 5, 2, 1, [0,1,2,3,4,5,6]))
            when "electricShock"
                @runEffects.push(Effect.new(x, y, "ThunderShock", 5, 2, 1, [0,1,2,3,4,5,6]))
            when "blunt"
                @runEffects.push(Effect.new(x, y, "bluntWeapon", 5, 2, 1, [0,1,2,3]))
            when "magicCircle"
                @runEffects.push(Effect.new(x, y, "Action01", 5, 2, 2, [0,2,3,4]))
            else 
                puts("FAIL") 
                
        end
    end

    def draw
        if @runEffects.length > 0
            @runEffects.each {|effect|
                effect.draw(nil,1,1,0xff,0xffffff,nil,@flip)
            }
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