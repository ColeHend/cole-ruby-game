require_relative "../../files/animate.rb"
require_relative "move_collision.rb"
require_relative "movement_control.rb"
require_relative "../player_control.rb"
require_relative "hpbar.rb"
class Event #$scene_manager.scene["player"].player
  attr_accessor :animate,:canMove,:moveType,:distance,:moving,:x,:y,:w,:h,:dir,:vector
  attr_accessor :collidable, :battle, :activateType, :eventObject, :facing, :name

  #include  Animate, Control_movement
  def initialize(object, eventTrigger, collidable, event,battle)
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
    @fightControl = FightCenter.new(@name)
    @eventObject = object
    @vector = Vector2.new(0, 0)
    @z = 5
    @dir = 8
    @battle = battle
    
    @eventTrigger = eventTrigger
    @solid = collidable
    @moveType = "none"
    if @moveType == "player"
      @playerControl = PlayerControl.new()
    else
      @moveControl = Control_movement.new(battle.name)
    end
    @activateType = "SELECT" # SELECT or TOUCH options
    @distance = 1
    @hpbar = HPbar.new(@x,@y,@battle.hp,@battle.currentHP)
    
    @event = event
    @moving = false
    @animate, @canMove, @facing = false, true, "down"

  end

  def set_move(kind,dist=12*32,innerDist=4*32,atkType="ranged",objectOfFocus=$scene_manager.scene["player"])
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
        
      when "none"
    end
  end

  def activate_event
    @event.call
  end

  def update(actionKeyTriggered = KB.key_pressed?(InputTrigger::SELECT))
    @moveControl.update
    @fightControl.update
    @player = $scene_manager.scene["player"]
    @battle = battle
    if @eventObject != nil
      @x = @eventObject.x 
      @y = @eventObject.y
      @w = @eventObject.w
      @h = @eventObject.h
    else
      @x = 0
      @y = 0
      @w = 0
      @h = 0
    end
    if @battle.currentHP > 0
      @hpbar.update(@x,@y,@battle.hp,@battle.currentHP)
      set_move(@moveType)
    end
    if @moveType == "player"
      @playerControl.update
      @facing = @playerControl.facing
    end
  end
  def w
    return @w
  end
  def draw()
    @moveControl.draw
    @fightControl.draw
    if @moveType == "player"
      @playerControl.draw
    end
    if @battle.currentHP > 0 && @eventObject != nil
      @eventObject.draw()
      @hpbar.draw
    end
    #draw_character(@sprite,@dir,@x,@y,@z,@animate,@canMove,@time,@frame,@moving)
  end
end
