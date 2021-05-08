require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "movement_control.rb"
require_relative "../player_control.rb"
require_relative "../scene_map.rb"
require_relative "hpbar.rb"
class Event #$scene_manager.scene["player"].eventObject
  attr_accessor :animate,:canMove,:moveType,:distance,:moving,:x,:y,:w,:h,:dir,:vector,:page
  attr_accessor :battle, :activateType, :eventObject, :facing, :name, :playerControl,:randomTime

  #include  Animate, Control_movement
  def initialize(object, event,battle)
    if object != nil
      @x = object.x 
      @y = object.y
      @w = object.w
      @h = object.h
      
    else
      @x = 0 
      @y = 0
      @w = 32
      @h = 32
    end
    @self = self
    @page = 1
    @moveArray = Array.new
    @name = battle.name
    @fightControl = FightCenter.new(@name,battle,Gosu::milliseconds())
    @eventObject = object
    @vector = Vector2.new(0, 0)
    @z = 5
    @dir = 8
    @battle = battle
    @moveType = "none"
    @randomTime = Gosu::milliseconds()
    @moveControl = Control_movement.new(battle.name)
    @activateType = "SELECT" # SELECT or TOUCH options
    @distance = 1
    @hpbar = HPbar.new(@x,@y,@battle.hp,@battle.currentHP)
    @event = event
    @moving = false
    @animate, @canMove, @facing = false, true, "down"
    
  end

  def isAnEnemy(baddy,goody)
    goody.enemyGroups.each {|e|
    if baddy.is_a?(Event)
        if baddy.battle.hateGroup == e
            return true
        end
    end
    }
    return false
  end

  def focus(detectDist,currentFocus)
    if MoveCollision.new.check_inRange(@eventObject,detectDist ,false) == true
      theEnemy = MoveCollision.new.check_inRange(@eventObject,detectDist,true)

      if theEnemy.is_a?(Event)
        if isAnEnemy(theEnemy,@battle)
          currentFocus = theEnemy.eventObject
          return currentFocus
          
        end
        
      end
    end
    return currentFocus
  end
  
  def set_move(kind,dist=12*32,objectOfFocus=nil,atkType="ranged",speed=0.25)
    canMove()
    @moveType = kind
    @distance = dist
    vector2 = Vector2.new(0, 0)
    
    case @moveType
      when "random"
        randomDir = rand(4)
        @moveControl.RandomMove(@vector,@eventObject,dist,@moveArray,@facing,@randomTime)

      when "followPlayer"
        if @eventObject.w != nil || @eventObject.h != nil
          #  Follow(vectorToMove,attackerClass, objectToMove,atkType="melee",range=6*32,nearDist,objectToFollow,moveArray)
          @moveControl.Follow(vector2,self, @eventObject,dist,focus(dist,objectOfFocus),@moveArray,speed)
        end

      when "newFollow"
        if @eventObject.w != nil || @eventObject.h != nil
          #  newFollow(attackerClass,objectToMove,vectorToMove,objectToFollow,moveArray)
          @moveControl.newFollow(self,@eventObject,vector2,focus(dist,objectOfFocus),@moveArray)
        end

      when "attack"
        if @eventObject.w != nil || @eventObject.h != nil
          @facing
          focus(dist,objectOfFocus)
          @fightControl.eventAtkChoice(@self,@battle,@facing,dist,focus(dist,objectOfFocus),atkType) #  <- Starts its attack logic
        end

      when "player"
        @moveType = "player"
        @playerControl = PlayerControl.new()
        
      when "none"
    end
  end

  def activate_event
    @event.call
  end

  def update(actionKeyTriggered = KB.key_pressed?(InputTrigger::SELECT))
    @player = $scene_manager.scene["player"]
    
    if @eventObject != nil
      @x = @eventObject.x 
      @y = @eventObject.y
      @w = @eventObject.w
      @h = @eventObject.h
    end
    if self.battle.currentHP > 0
      @battle = battle
      if @moveType == "player"
        @facing = @playerControl.facing
        @playerControl.update
        @battle.totalArmor = @battle.total_ac(0)
      else
        @moveControl.update
        @fightControl.update
        if @moveArray.length > 0
          moveTiming = 3 # $time/100 % 4
          #puts("Time divide and modulus: #{moveTiming}") 
          #puts("Time divide: #{$time/100}")
          if moveTiming  == 3
            @moveArray[0].call()
            @moveArray.delete_at(0)
          end
        end
        set_move(@moveType)
      end
      @hpbar.update(@x,@y,@battle.hp,@battle.currentHP)
    elsif self.battle.currentHP <= 0
    end
    if self.battle.name == "god"
      self.battle.currentHP = self.battle.hp
    end
  end
  
  def draw()
    
    
    
    if self.battle.currentHP > 0 && @eventObject != nil
      if @moveType == "player"
        @playerControl.draw
      else
        @moveControl.draw
        @fightControl.draw
      end
      @eventObject.draw()
      @hpbar.draw
    end
    #draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
  end
end
