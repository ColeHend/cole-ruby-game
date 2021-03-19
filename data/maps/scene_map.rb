Dir[File.join(__dir__, 'maps', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'files', '*.rb')].each { |file| require file }
require_relative '../gameover.rb'
class SceneMap
    attr_accessor :currentMap, :mapHash
    def initialize()
        @mapHash = Hash.new()
        @mapHash["map1"] = Map01.new()
        @mapHash["map2"] = Map02.new()
        startMap = @mapHash["map1"]
        @currentMap = startMap
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @deathCap = @party.maxPartySize
        @deathTotal = 0
        @input = $scene_manager.input # need to add to input stack
        @stackSpot = $scene_manager.input.inputStack.length 
        @mWidth = 40  # @mWidth = @currentMap.map.width
        @mHeight = 30   # @mHeight = @currentMap.map.height
        @camera_x = @camera_y = 0
    end 
    def change_map(map)
        $scene_manager.input.addToStack("map")
        @currentMap = @mapHash[map]
    end
    def will_Collide(collisionArray,key)
        @currentMap.willCollide(collisionArray,@player.x,@player.y,key)
    end
    def update()
        @party.party.each {|e| 
            if e.currentHP <= 0 && e.alive == true
                @deathTotal += 1
                e.alive = false
            end
        }
        if @deathTotal >= @deathCap
            $scene_manager.switch_scene("gameover")
        end
        @player.update()#update player 
        @currentMap.update()#update map
        #@currentMap.events.each {|e|@currentMap.map.collision[e.x][e.y] = 1}#update events collision
        stackLength = ($scene_manager.input.inputStack.length-1)
        if $scene_manager.input.inputStack[stackLength] == "map"
            @currentMap.events.each {|e|    #updates events
                e.update(@player.x, @player.y, KB.key_pressed?(InputTrigger::SELECT))
            } 
            @player.move(@input, @currentMap.map.theMap)
        end
        @camera_x = [[(@player.x) - 800 / 2, 0].max, @mWidth * 32 - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, @mHeight * 32 - 600].min
    end
    def draw()
        
        @player = $scene_manager.scene["player"]
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw#draw map
            @player.draw #draw player
            @currentMap.events.each {|e|e.draw()} #draw events
            
        end
        @currentMap.draw
    end
end