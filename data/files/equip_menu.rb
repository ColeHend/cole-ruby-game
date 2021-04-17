require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
class EquipMenu
    include WindowBase
    def initialize()
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        #options
        startOptions = [Option.new("Equip",->(){})]
        @currentOptions = startOptions
        @optionsBox = OptionsBox.new("Equipment",0,0,6,19,@currentOptions,"")
        # Colors
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        #equipment
        @partyNames = @party.party.map{|e|Gosu::Image.from_text(e.name, 25)}
        @partyWeapons = @party.weapons.map{|e|Option.new(e.name,->(){})}
        @partyArmor = @party.armor.map{|e|Option.new(e.name,->(){})}
        #armor
        @currentArmorOp = 0 
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor
    end

    def update
        @optionBox.update
    end

    def draw
        @optionBox.draw
        create_window(6,0,19,19) 
    end
end