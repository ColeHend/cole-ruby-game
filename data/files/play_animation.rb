class PlayAnimation
    def initialize()
        @drawAnimation = nil
    end

    def play_animation(animation="slash",x,y)
        case animation
            when "slash"
                @doingAnimate = true
                weapons04 = GameObject.new(x, y, 0, 0, "Weapon04", nil, 5, 5)
                @drawAnimation = weapons04
                @drawAnimation.animate([0,1,2,3,4],2) 
            else 
                puts("FAIL") 
                
        end
    end

    def draw
            @drawAnimation.draw
    end

    def update
    end
end