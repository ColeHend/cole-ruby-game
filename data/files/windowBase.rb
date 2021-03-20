module WindowBase
    def create_window(x,y,width,height) #use the same grid pattern as events use ("fancyWindowSkin",,0,0,0,0,6,4)
        @windowSkin = GameObject.new(0,0, 0, 0, "fancyWindowSkin", nil, 6, 4)
        for a in (0..width) do
            for b in (0..height) do
                @windowSkin.set_animation(0)
                @windowSkin.x = ((x+a)*32)
                @windowSkin.y = ((y+b)*32)
                #@windowSkin.draw(nil, 1, 1, 0xff, 0xff, nil, nil, 6, false)
                @windowSkin.draw#(map = nil, scale_x = 1, scale_y = 1, alpha = 0xffffff, color = 0xffffff, angle = nil, flip = nil, z_index = 0, round = false)
                #@windowSkin.animate([0],8)
                if a == 0 && b == 0
                    @windowSkin.set_animation(4)
                    #@windowSkin.animate([4],8)
                    @windowSkin.x = (x*32)
                    @windowSkin.y = (y*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == width && b == 0
                    @windowSkin.set_animation(5)
                    #@windowSkin.animate([5],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == width && b == height
                    @windowSkin.set_animation(11)
                    #@windowSkin.animate([11],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == 0 && b == height
                    @windowSkin.set_animation(10)
                    #@windowSkin.animate([10],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                end
            end
        end
    end
     
end