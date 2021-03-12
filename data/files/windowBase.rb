module WindowBase
    def create_window(x,y,width,height) #use the same grid pattern as events use
        @windowSkin = $scene_manager.images["windowSkin"]
        for a in (0..width) do
            for b in (0..height) do
                @windowSkin[0].draw(((x+a)*32),((y+b)*32),6)
                if a == 0 && b == 0
                    @windowSkin[4].draw((x*32),(y*32),7)
                elsif a == width && b == 0
                    @windowSkin[5].draw(((x+a)*32),((y+b)*32),7)
                elsif a == width && b == height
                    @windowSkin[11].draw(((x+a)*32),((y+b)*32),7)
                elsif a == 0 && b == height
                    @windowSkin[10].draw(((x+a)*32),((y+b)*32),7 )
                end
            end
        end
    end
     
end