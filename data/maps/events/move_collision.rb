require_relative "../../files/animate.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"
#Dir[File.join(__dir__, '*.rb')].each { |file| require file }
module MoveCollision
    
    def overlap?(r1,r2)
        !(r1.first > r2.last || r1.last < r2.first)
    end

    def checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        eventArray = $scene_manager.scene["map"].currentMap.events
        eventArray.each {|event|
        range = 33 + rangeBoost
        targetX = targetObject.x
        targetY = targetObject.y
        targetW = targetObject.w
        targetH = targetObject.h
        eventX = event.x
        eventY = event.y
        eventW = event.w
        eventH = event.h
        case dir
            when "up"
                if (range+6) >= (eventY+(eventH) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range-16) #up
                    if (overlap?(((eventY)...(eventY+eventH+8)),(targetY...(targetY+targetH))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                        if evtReturn == true
                            return event
                        else
                            return true
                        end
                    end
                end
            when "down"
                if range >= (eventY+(16) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range-16) #down
                    if (overlap?(((eventY)...(eventY+eventH)),(targetY...(targetY+targetH))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                        if evtReturn == true
                            return event
                        else
                            return true
                        end
                    end
                end
            when "left"
                if (range-2 ) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range) #up
                    if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH+8)),((targetY)...(targetY+targetH))) === true)
                        if evtReturn == true
                            return event
                        else
                            return true
                        end 
                    end
                end
            when "right"
                if (range-2 ) >= ((eventY) - targetY).abs && (eventX - (targetX + targetW)).abs <= (range) #up
                    if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH+8)),(targetY...(targetY+targetH))) === true)
                        if evtReturn == true
                            return event
                        else
                            return true
                        end
                    end
                end
        end
        }
    end

    def check_surrounding(direction,targetObject)
        #currentMap =  $scene_manager.scene["map"].currentMap 
        mWidth = 30
        mHeight = 20
        objectX = targetObject.x
        objectY = targetObject.y
        case direction
            when "up"
                if objectY <= 0 
                    return true
                elsif checkDir(targetObject,"up") == true#true collide
                    return true
                else
                    return false
                end
            when "down"
                if objectY >= (mHeight * 32-16)
                    return true
                elsif checkDir(targetObject,"down") == true#true collide
                    return true
                else
                    return false
                end
            when "left" 
                if objectX <= 1 
                    return true
                elsif checkDir(targetObject,"left") == true#true collide
                    return true
                else
                    return false
                end
            when "right" 
                if objectX >= (mWidth * 32) 
                    return true
                elsif checkDir(targetObject,"right") == true#true collide
                    return true
                else
                    return false
                end
        end
            
    end

    def check_collision(targetObject,rangeBoost = 0,evtReturn = false)
        if checkDir(targetObject,"up") == true
            if evtReturn == true
                event = checkDir(targetObject,"up",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"down") == true
            if evtReturn == true
                event = checkDir(targetObject,"down",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"left") == true
            if evtReturn == true
                event = checkDir(targetObject,"left",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"right") == true
            if evtReturn == true
                event = checkDir(targetObject,"right",rangeBoost,true)
                return event
            else
                return true
            end
        end
    end
        
    
        # ----Event Movement needs rewrite for vectors----
        moveRandom = ->(randomDir){}
        facePlayer = ->(sight=300){
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           range = 400
           if (x - targetX).abs <= range && (y - targetY).abs <= range
            if (y - targetY) <= 0  && (x - targetX) >= 0
               if (x-targetX).abs <= (y-targetY).abs
                @objectToMove.set_animation(12)
               else @objectToMove.set_animation(8)
               end
            elsif  (y - targetY) >= 0 && (x - targetX) <= 0
               if (x-targetX).abs <= (y-targetY).abs
                @objectToMove.set_animation(0)
               else @objectToMove.set_animation(4)
               end
            end
           end
        }
        
        followPlayer = ->(sight=2,betweenMove=100){
            @delayStop = Gosu.milliseconds
            #if (@delayStop - @delayStart < betweenMove)
           x = $scene_manager.scene["player"].x
           y = $scene_manager.scene["player"].y
           range = sight
            
         }
         
         #event.call(objectToMove)
end
