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
        @mapHash["map03"] = Map03.new()
        startMap = @mapHash["map01"]
        @currentMap = startMap
        @currentMap.bgm.play(true)
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

    def change_map(map,newX,newY,facing="down")
        $scene_manager.input.addToStack("map")
        @player.eventObject.x = newX
        @player.eventObject.y = newY
        case facing
        when "up"
            @player.eventObject.set_animation(12)
        when "down"
            @player.eventObject.set_animation(0)
        when "left"
            @player.eventObject.set_animation(4)
        when "right"
            @player.eventObject.set_animation(8)
        end
        if @currentMap.bgm.playing? == true
            @currentMap.bgm.stop
        end
        @currentMap = @mapHash[map]
        @currentMap.bgm.play
    end

    def will_Collide(collisionArray,key)
        @currentMap.willCollide(collisionArray,@player.x,@player.y,key)
    end
    def update()
        
        @party.party.each {|e| 
            if e.currentHP <= 0 && e.alive == true
                @deathTotal += 1
                e.alive = false
                $scene_manager.switch_scene("gameover")
            end
        }
        if @deathTotal >= @deathCap
            $scene_manager.switch_scene("gameover")
        end
        @player.update()#update player 
        @currentMap.update()#update map
        
        stackLength = ($scene_manager.input.inputStack.length-1)
        
        if $scene_manager.input.inputStack[stackLength] == "map"
            #@currentMap.events.each {|e| e.update()}#update events collision
            @currentMap.events.each_with_index {|e,index|    #updates events
                e.update(KB.key_pressed?(InputTrigger::SELECT))#
                deadEvents = Array.new
                if e.battle.currentHP <= 0
                    deadEvents.push([index,(e.battle.exp * 0.05)])
                end
                if deadEvents.length > 0
                    deadEvents.each {|e|
                        @party.party.each {|pers|
                            pers.give_xp(e[1])
                        }
                        @currentMap.events.delete_at(e[0])
                    }
                end
            } 
            
        end
        @mWidth = @currentMap.width 
        @mHeight = @currentMap.height
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        
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
            @currentMap.map.drawAbove
        end
        @currentMap.draw
    end
end