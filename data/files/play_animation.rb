class PlayAnimation
    def initialize()
        @drawAnimation = nil
        @off = true
    end

    def play_animation(animation="slash",x,y)
        case animation
            when "slash"
                @off = false
                weapons04 = GameObject.new(x, y, 0, 0, "Weapon04", nil, 5, 5)
                @drawAnimation = weapons04
                @drawAnimation.animate([0,1,2,3,4],2) do
                    @off = true
                    puts("calleed")
                end
            else 
                puts("FAIL") 
                
        end
    end

    def draw
        if @off == false
            @drawAnimation.draw
        end
    end

    def update
    end
end