require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "movement_control.rb"
require_relative "../player_control.rb"
require_relative "../scene_map.rb"
require_relative "hpbar.rb"
class Event #$scene_manager.scene["player"].eventObject
  attr_accessor :animate,:canMove,:moveType,:distance,:moving,:x,:y,:w,:h,:dir,:vector
  attr_accessor :battle, :activateType, :eventObject, :facing, :name, :playerControl

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
    
    @name = battle.name
    @fightControl = FightCenter.new(@name,battle)
    @eventObject = object
    @vector = Vector2.new(0, 0)
    @z = 5
    @dir = 8
    @battle = battle
    @moveType = "none"
    
    @moveControl = Control_movement.new(battle.name)
    @activateType = "SELECT" # SELECT or TOUCH options
    @distance = 1
    @hpbar = HPbar.new(@x,@y,@battle.hp,@battle.currentHP)
    
    @event = event
    @moving = false
    @animate, @canMove, @facing = false, true, "down"
    
  end

  def set_move(kind,dist=12*32,innerDist=8*32,atkType="ranged",objectOfFocus=nil)
    canMove()
    @moveType = kind
    @distance = dist
    vector2 = Vector2.new(0, 0)
    case @moveType
      when "random"
        randomDir = rand(4)
        startTime = Gosu.milliseconds
        @moveControl.RandomMove(@vector,@eventObject,randomDir,startTime)
      when "followPlayer"
        if @eventObject.w != nil || @eventObject.h != nil
          @moveControl.Follow(vector2,self, @eventObject,atkType,dist,objectOfFocus)
          @fightControl.eventAtkChoice(@eventObject,@battle,@facing,dist,innerDist,atkType,objectOfFocus) #  <- Starts its attack logic
        end
      when "player"
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
      else
        @moveControl.update
        @fightControl.update
        set_move(@moveType)
      end
      @hpbar.update(@x,@y,@battle.hp,@battle.currentHP)
    elsif self.battle.currentHP <= 0
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
