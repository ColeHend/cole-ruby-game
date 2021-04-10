Dir[File.join(__dir__, 'maps', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'files', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'maps', 'events', '*.rb')].each { |file| require file }
require_relative '../gameover.rb'
class SceneMap
    attr_accessor :currentMap, :mapHash
    def initialize()
        @currentMap = Hash.new()
        @mapHash = Hash.new()
        @mapHash["map01"] = Map01.new()
        @mapHash["map02"] = Map02.new()
        startMap = @mapHash["map01"]
        @currentMap = startMap
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @deathCap = @party.maxPartySize
        @deathTotal = @party.deathTotal
        @input = $scene_manager.input # need to add to input stack
        @stackSpot = $scene_manager.input.inputStack.length 
        @mWidth = @currentMap.width  # @mWidth = @currentMap.map.width
        @mHeight = @currentMap.height   # @mHeight = @currentMap.map.height
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
                $scene_manager.input.removeFromStack("map")
                $scene_manager.switch_scene("gameover")
            end
        }
        if @deathTotal >= @deathCap
            $scene_manager.switch_scene("gameover")
        end
        @player.update()#update player 
        @currentMap.update()#update map
        
        stackLength = ($scene_manager.input.inputStack.length-1)
        deadEvents = Array.new
        if $scene_manager.input.inputStack[stackLength] == "map"
            #@currentMap.events.each {|e| e.update()}#update events collision
            @currentMap.events.each_with_index {|e,index|    #updates events
                e.update(KB.key_pressed?(InputTrigger::SELECT))#
                if e.battle.currentHP <= 0
                    deadEvents.push([index,(e.battle.exp * 0.05)])
                end
            } 
            if deadEvents.length > 0
                deadEvents.each {|e|
                    @party.party.each {|pers|
                        pers.give_xp(e[1])
                    }
                    @currentMap.events.delete_at(e[0])
                }
            end
        end
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        $scene_manager.scene["player"].set_move("player")
    end
    def draw()
        
        @player = $scene_manager.scene["player"]
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw
            if @currentMap.events.length > 0
                @currentMap.events.each {|e|
                    if @player.y >= e.y
                        e.draw()
                        @player.draw 
                    elsif @player.y < e.y
                        @player.draw 
                        e.draw()
                    end
                }
            else
                @player.draw
            end
             # events
            
        end
        @currentMap.draw
    end
end