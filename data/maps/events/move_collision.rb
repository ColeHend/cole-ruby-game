require_relative "../../files/animate.rb"
require_relative "../scene_map.rb"
require_relative "../map.rb"
require_relative "../map01.rb"
require_relative "../map02.rb"
#Dir[File.join(__dir__, '*.rb')].each { |file| require file }
class MoveCollision
    def initialize(name="lame")
        @player = $scene_manager.scene["player"]
        @name = name
    end
    def overlap?(r1,r2)
        !(r1.first > r2.last || r1.last < r2.first)
    end

    def collideCheck(targetObject,event,dir,rangeBoost,evtReturn)
        range = 33 + rangeBoost
        
        if event != nil && targetObject != nil
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
                    if (range + 6) >= (eventY + (eventH) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range - 16) #up
                        if (overlap?(((eventY)...(eventY+eventH+8)),(targetY...(targetY+targetH))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "down"
                    if range >= (eventY+(16) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range-16) #down
                        if (overlap?(((eventY)...(eventY+eventH)),(targetY...(targetY+targetH))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "left"
                    if (range-2 ) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range) #up
                        if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH+8)),((targetY)...(targetY+targetH))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "right"
                    if (range-2 ) >= ((eventY) - targetY).abs && (eventX - (targetX + targetW)).abs <= (range) #up
                        if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH+8)),(targetY...(targetY+targetH))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
            end
        else
            puts("collideCheck skipped..")
        end
    end
    def sameOb(obj1,obj2)
        #if obj1.x == obj2.x
            #if obj1.y == obj2.y
                if obj1.w == obj2.w
                    if obj1.h == obj2.h
                        return true
                    end
                end
            #end
        #end
        return false
    end
    def checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        playerObj = $scene_manager.scene["player"]

        $scene_manager.scene["map"].currentMap.events.each {|event|
            
            if collideCheck(targetObject,playerObj,dir,rangeBoost,false) == true
                if sameOb(targetObject,playerObj) == false
                    if evtReturn == true
                        playa = collideCheck(targetObject,playerObj,dir,rangeBoost,true)
                        #puts("checkDir player return #{playa.battle.name}")
                        return playa
                    end
                    return true
                end
            elsif collideCheck(targetObject,event,dir,rangeBoost,false) == true
                if sameOb(targetObject,event) == false
                    if evtReturn == true
                        #puts("event: #{collideCheck(targetObject,event,dir,rangeBoost,false)}")
                        return event
                    end
                    return true
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
        playerObj = $scene_manager.scene["player"].eventObject
        
        case direction
            when "up"
                if objectY <= 0 
                    return true
                elsif checkDir(targetObject,"up",8) == true#check events
                    return true
                else
                    if sameOb(targetObject,playerObj) == false
                        if collideCheck(targetObject,playerObj,direction,8,false) == true
                            return true 
                        end
                    end
                    return false
                end
            when "down"
                if objectY >= (mHeight * 32-16)
                    return true
                elsif checkDir(targetObject,"down",8) == true#true collide
                    return true
                else
                    if sameOb(targetObject,playerObj) == false
                        if collideCheck(targetObject,playerObj,direction,8,false) == true
                            return true 
                        end
                    end
                    return false
                end
            when "left" 
                if objectX <= 1 
                    return true
                elsif checkDir(targetObject,"left",8) == true#true collide
                    return true
                else
                    if sameOb(targetObject,playerObj) == false
                        if collideCheck(targetObject,playerObj,direction,8,false) == true
                            return true 
                        end
                    end
                    return false
                end
            when "right" 
                if objectX >= (mWidth * 32) 
                    return true
                elsif checkDir(targetObject,"right",8) == true#true collide
                    return true
                else
                    if sameOb(targetObject,playerObj) == false
                        if collideCheck(targetObject,playerObj,direction,8,false) == true
                            return true 
                        end
                    end
                    return false
                end
        end
            
    end

    def check_collision(targetObject,rangeBoost = 0,evtReturn = false)
        if checkDir(targetObject,"up",rangeBoost) == true
            if evtReturn == true
                event = checkDir(targetObject,"up",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"down",rangeBoost) == true
            if evtReturn == true
                event = checkDir(targetObject,"down",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"left",rangeBoost) == true
            if evtReturn == true
                event = checkDir(targetObject,"left",rangeBoost,true)
                return event
            else
                return true
            end
        elsif checkDir(targetObject,"right",rangeBoost) == true
            if evtReturn == true
                event = checkDir(targetObject,"right",rangeBoost,true)
                return event
            else
                return true
            end
        end
    end
   
         #event.call(objectToMove)
end
