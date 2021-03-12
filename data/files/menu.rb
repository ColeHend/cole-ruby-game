require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
class Menu
    include WindowBase
    def initialize()
        @input = $scene_manager.input
        
        @party = $scene_manager.feature["party"].party
        @showItems = false
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.hp.to_s+"/"+e.currentHP.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        @items = Array.new
        @inventory = $scene_manager.feature["party"].inventory
        if @inventory.size >= 1
            @items = @inventory.each_with_index.map{|e,index| Option.new(e.name,->(){
            $scene_manager.feature["party"].use_item(index,@party[0])})}
        else
            @items = [Option.new("No Items",->(){})]
        end

        @options = [Option.new("Party",->(){}),
            Option.new("Items",->(){
                @showItems = true
                @itemsBox.hidden(false)
                activateItems() }),
            Option.new("Save",->(){}),
            Option.new("Exit Game",->(){})]
        @itemsBox = OptionsBox.new("itemsBox",5,0,3,8,@items,"")
        @optionsBox = OptionsBox.new("options",0,0,3,8,@options,"")
        
        
    end
    def activateItems()
        if (Gosu.milliseconds / 50 % 3 == 0)
            @input.addToStack("itemsBox")
        end
    end

    def update()
        @optionsBox.update
        if @showItems == true
            @itemsBox.update
        end
        
        if $window.button_down(InputTrigger::ESCAPE)
            if @showItems == true
                @input.removeFromStack(@itemsBox.stackName)
                @showItems = false
                @itemsBox.hidden(true)
            else
                @input.removeFromStack(@optionsBox.stackName)
                @input.addToStack("map")
                $scene_manager.switch_scene("map")
            end
        end
    end

    def draw()
        @partyNames = @party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyHP = @party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyLVL = @party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        create_window(10,0,10,10)
        for a in (0...@party.length)
            @partyNames[a].draw((10*32)+(74*a), 20, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyLVL[a].draw((10*32)+(74*a), 45, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyXP[a].draw((10*32)+(74*a), 70, 8,scale_x = 1, scale_y = 1, color = @white)
            @partyHP[a].draw((10*32)+(74*a), 95, 8,scale_x = 1, scale_y = 1, color = @white)
         #   puts("drawed!")
        end
        @player = $scene_manager.scene["player"]
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height
        @camera_x = [[(@player.x*32) - 640 / 2, 0].max, @mWidth * 50 - 640].min
        @camera_y = [[(@player.y*32) - 480 / 2, 0].max, @mHeight * 50 - 480].min
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.draw
            @currentMap.events.each {|e|e.draw()}
            @player.draw
        end    
        @optionsBox.draw
        if @showItems == true
            @itemsBox.draw
        end
        if @inventory.size >= 1
            @items = @inventory.each_with_index.map{|e,index| Option.new(e.name,->(){
            $scene_manager.feature["party"].use_item(index,@party[0])})}
        else
            @items = [Option.new("No Items",->(){})]
        end
    end
end