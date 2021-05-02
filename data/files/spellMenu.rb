require_relative "windowBase.rb"
class SpellMenu
    include WindowBase
    def initialize()
        @input = $scene_manager.input
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @currentChoiceOp = 0
        @currentPartyMember = 0
        @spellOptions = Array.new
        @startOptions = @party.party.each_with_index.map{|member,index| 
            Option.new(member.name,->(){
                @currentPartyMember = index
                @spellOptions = spellOptions()
                @currentOptions = @spellOptions
                @optionsBox.change_options(@spellOptions)
                #@optionsBox = OptionsBox.new("Equipment",0,0,4,19,@spellOptions,"")
            })
        }
        @currentOptions = @startOptions
        @optionsBox = OptionsBox.new("spellMenu",0,0,4,10,@startOptions,"")

        #   Colors
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @notCurrentColor = @white
        @currentColor = @brightGreen

        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor
    end
    def amountIsNone(spells) # return if an array is empty
        if spells != nil
            if spells.length > 0 && spells != nil
                return false
            else 
                return true
            end
        end
    end
    def spellOptions()
        array = Array.new
        array = @party.party[@currentPartyMember].knownSpells.each.map{|e|
            Option.new(Spellbook.new.spell(e).name,->(){ #Actual spell option
                @party.party[@currentPartyMember].currentSpell = Spellbook.new.spell(e)
                @currentOptions = @startOptions
                @optionsBox.change_options(@startOptions)
        })
        }
        if amountIsNone(array) == true
            array = [Option.new("none",->(){})]
        end
        array.push(Option.new("Back",->(){
            @optionsBox.change_options(@startOptions)
        }))
        return array
    end
    def update
        @choiceNames = @currentOptions.map{|e|e.text_image}
        @currentChoices =  @currentOptions.map{|e|e.function}
        @choiceAmount = @currentOptions.length
        @currentChoiceOp = @optionsBox.currentOp
        @optionsBox.update

        if @input.keyPressed(InputTrigger::UP) then # Up Arrow
            if @currentChoiceOp != 0
                @colors[@currentChoiceOp] = @notCurrentColor
                @currentChoiceOp -= 1
                @colors[@currentChoiceOp] = @currentColor
            end 
        elsif @input.keyPressed(InputTrigger::DOWN) then #Down Arrow
            if @choiceAmount != (@currentChoiceOp+1)
                @colors[@currentChoiceOp] = @notCurrentColor
                @currentChoiceOp += 1
                @colors[@currentChoiceOp] = @currentColor
            end
        elsif @input.keyPressed(InputTrigger::SELECT) then #Select Key
            if @currentChoices[@currentChoiceOp] != nil
                @currentChoices[@currentChoiceOp].call()
            end
            
        end
        if @input.keyPressed(InputTrigger::ESCAPE) then #Escape Key
            @input.removeFromStack(@optionsBox.stackName)
            $scene_manager.switch_scene("menu")
            @input.addToStack("options")
        end
    end

    def draw
        @currentMap =  $scene_manager.scene["map"].currentMap
        @mWidth, @mHeight = @currentMap.width, @currentMap.height
        #draw boxes
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@mWidth * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@mHeight * 32) + 32) - 600].min
        Gosu.translate(-@camera_x, -@camera_y) do
            @currentMap.map.draw
            @currentMap.events.each {|e|e.draw()}
            @player.draw
            @currentMap.map.drawAbove
        end 
        
        @optionsBox.draw
    end
end