require_relative "battle/battle_core.rb"
require_relative "event_core.rb"
class Event_NPC < Event_Core
    attr_accessor :stats
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,bbHeight,bbWidth)
        super(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,4,4,bbHeight,bbWidth)
        @stats = Battle_Core.new(eventName)
        @moveType = "none"
        @moveController = nil
    end
    def setMoveRandom(distance)
        @moveType = "random"
        randomDir = rand(4)
        @moveControl.RandomMove(self.vector,self,dist,[],self.facing,Gosu::milliseconds())
    end
    def setMoveFollow(distance,objectOfFocus)
        @moveType = "newFollow"
        if @eventObject.w != nil || @eventObject.h != nil
            #  newFollow(attackerClass,objectToMove,vectorToMove,objectToFollow,moveArray)
            vector2 = Vector2.new(0, 0)
            @moveControl.newFollow(self,@eventObject,vector2,focus(dist,objectOfFocus),@moveArray)
          end
    end
    def setMoveAttack(distance,objectOfFocus,atkType)
        if @eventObject.w != nil || @eventObject.h != nil
            @facing
            focus(dist,objectOfFocus)
            @fightControl.eventAtkChoice(@self,@battle,@facing,dist,focus(dist,objectOfFocus),atkType) #  <- Starts its attack logic
          end
    end
    def setMovePlayer()
        @moveType = "player"
        @moveController = PlayerControl.new()
    end
    def update
        if @moveType != "none"
            @moveController.update()
        end
    end
    def draw
        if @moveType != "none"
            @moveController.draw()
        end
        draw_character(self, self.facing,6)
    end
end