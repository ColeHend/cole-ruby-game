require_relative "input_trigger.rb"
require_relative "option.rb"
require_relative "optionsBox.rb"
require_relative "windowBase.rb"
require_relative "../maps/characters/inventory.rb"
class EquipMenu
    include WindowBase
    def initialize()
        @input = $scene_manager.input
        @player = $scene_manager.scene["player"]
        @party = $scene_manager.feature["party"]
        @currentChoiceOp = 0
        @currentPartyMember = 0
        @currentLayer = "party"
        @equipmentOptions=Array.new
        
        #   Options
        back = [Option.new("Back",->(){
            @input.removeFromStack(@optionsBox.stackName)
            $scene_manager.switch_scene("menu")
        })]
        @currentOptions = back
        @optionsBox = OptionsBox.new("Equipment",0,0,4,19,@currentOptions,"")
        
        #   Equipment
        
        @partyNames = @party.party.map{|e|Gosu::Image.from_text(e.name, 25)}
        
        #list of party members
        @startOptions = @party.party.each_with_index.map{|member,index| 
            Option.new(member.name,->(){
                @currentPartyMember = index
                @currentOptions = @equipmentOptions
                @optionsBox.change_options(@equipmentOptions)
            })
        }
        @startOptions.push(back[0])
        mapPartyEquipment()
        
        @equipmentOptions =  [
            Option.new("Weapon",->(){
                @currentOptions = @partyWeaponsList
                @optionsBox.change_options(@partyWeaponsList)
            }),
            Option.new("Shield",->(){
                @currentOptions = @partyShieldArmor
                @optionsBox.change_options(@partyShieldArmor)
            }),
            Option.new("Head",->(){
                @currentOptions = @partyHeadArmor
                @optionsBox.change_options(@partyHeadArmor)
            }),
            Option.new("Neck",->(){
                @currentOptions = @partyNeckArmor
                @optionsBox.change_options(@partyNeckArmor)
            }),
            Option.new("Body",->(){
                @currentOptions = @partyBodyArmor
                @optionsBox.change_options(@partyBodyArmor)
            }),
            Option.new("Hands",->(){
                @currentOptions = @partyHandsArmor
                @optionsBox.change_options(@partyHandsArmor)
            }),
            Option.new("Legs",->(){
                @currentOptions = @partyLegsArmor
                @optionsBox.change_options(@partyLegsArmor)
            }),
            Option.new("Feet",->(){
                @currentOptions = @partyFeetArmor
                @optionsBox.change_options(@partyFeetArmor)
            }),
            Option.new("Back",->(){
                @currentOptions = @startOptions
                @optionsBox.change_options(@startOptions)
        })]
        #change to party options
        @currentOptions = @startOptions
        @optionsBox.change_options(@startOptions)

        #   Colors
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @currentEquipColor = @white
        @equipColors = Array.new(5,@black)
        
        

        #   Armor 
        #Types Are : "head","neck", "body", "hands", "legs", "feet"
        @currentArmorOp = 0 
        
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor
    end
    def amountIsNone(equipment) # return if an array is empty
        if equipment != nil
            if equipment.length > 0 && equipment[0] != nil
                return false
            else 
                return true
            end
        end
    end
    def armorArray(arrayType)
        array = Array.new
        @party.inventory.armor.each{|e|
            if e.type == arrayType
                array.push(e)
            end
        }
        return array
    end
    def mapPartyEquipment()
        @partyWeapons = @party.party.map{|e|
        if e.weapon != nil
            Gosu::Image.from_text("Weapon: #{e.weapon.name}", 18)
        else
            Gosu::Image.from_text("Weapon: None", 18)
        end
        }
        @partyShield = @party.party.map{|e|
        if e.shield != nil
            Gosu::Image.from_text("Shield: #{e.shield.name}", 18)
        else
            Gosu::Image.from_text("Shield: None", 18)
        end
        }
        @partyHead = @party.party.map{|e|
        if e.helm != nil
            Gosu::Image.from_text("Head: #{e.helm.name}", 18)
        else
            Gosu::Image.from_text("Head: None", 18)
        end
        }
        @partyNeck = @party.party.map{|e|
        if e.necklace != nil
            Gosu::Image.from_text("Neck: #{e.necklace.name}", 18)
        else
            Gosu::Image.from_text("Neck: None", 18)
        end
        }
        @partyBody = @party.party.map{|e|
        if e.chest != nil
            Gosu::Image.from_text("Body: #{e.chest.name}", 18)
        else
            Gosu::Image.from_text("Body: None", 18)
        end
        }
        @partyHands = @party.party.map{|e|
        if e.hands != nil
            Gosu::Image.from_text("Hands: #{e.hands.name}", 18)
        else
            Gosu::Image.from_text("Hands: None", 18)
        end
        }    
        @partyLegs = @party.party.map{|e|
        if e.legs != nil
            Gosu::Image.from_text("Legs: #{e.legs.name}", 18)
        else
            Gosu::Image.from_text("Legs: None", 18)
        end
        }
        @partyFeet = @party.party.map{|e|
        if e.feet != nil
            Gosu::Image.from_text("Feet: #{e.feet.name}", 18)
        else
            Gosu::Image.from_text("Feet: None", 18)
        end
        }
        #equiment options
        #--------------------------
        equipBack = Option.new("Back",->(){
            @currentOptions = @equipmentOptions
            @optionsBox.change_options(@equipmentOptions)
        })
        #--------------------------- @party.unequip(equipItem,equipSpot)
        @partyWeaponsList = @party.inventory.weapons.each.map{|e|
        if e.is_a?(Weapon) == true
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        end
        }
        if amountIsNone(@partyWeaponsList) == true
            @partyWeaponsList = [Option.new("none",->(){})]
        end
        @partyWeaponsList.push(Option.new("Unequip",->(){@party.unequip("weapon",@currentPartyMember)}))
        @partyWeaponsList.push(equipBack)

        
        @partyHeadArmor = armorArray("head").each.map{|e| #head
            Option.new(e.name,->(){})
        }
        if amountIsNone(@partyHeadArmor) == true
            @partyHeadArmor = [Option.new("none",->(){})]
        end
        @partyHeadArmor.push(Option.new("Unequip",->(){@party.unequip("head",@currentPartyMember)}))
        @partyHeadArmor.push(equipBack)

        @partyShieldArmor = armorArray("shield").each.map{|e| #shield
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyShieldArmor) == true
            @partyShieldArmor = [Option.new("none",->(){})]
        end
        @partyShieldArmor.push(Option.new("Unequip",->(){@party.unequip("shield",@currentPartyMember)}))
        @partyShieldArmor.push(equipBack)

        @partyNeckArmor = armorArray("neck").each.map{|e| #neck
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyNeckArmor) == true
            @partyNeckArmor = [Option.new("none",->(){})]
        end
        @partyNeckArmor.push(Option.new("Unequip",->(){@party.unequip("neck",@currentPartyMember)}))
        @partyNeckArmor.push(equipBack)

        @partyBodyArmor = armorArray("body").each.map{|e| #body
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyBodyArmor) == true
            @partyBodyArmor = [Option.new("none",->(){})]
        end
        @partyBodyArmor.push(Option.new("Unequip",->(){@party.unequip("body",@currentPartyMember)}))
        @partyBodyArmor.push(equipBack)

        @partyHandsArmor = armorArray("hands").each.map{|e| #hands
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyHandsArmor) == true
            @partyHandsArmor = [Option.new("none",->(){})]
        end
        @partyHandsArmor.push(Option.new("Unequip",->(){@party.unequip("hands",@currentPartyMember)}))
        @partyHandsArmor.push(equipBack)

        @partyLegsArmor = armorArray("legs").each.map{|e| #legs
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyLegsArmor) == true
            @partyLegsArmor = [Option.new("none",->(){})]
        end
        @partyLegsArmor.push(Option.new("Unequip",->(){@party.unequip("legs",@currentPartyMember)}))
        @partyLegsArmor.push(equipBack)

        @partyFeetArmor = armorArray("feet").each.map{|e| #feet
            Option.new(e.name,->(){@party.equip(e,@currentPartyMember)})
        }
        if amountIsNone(@partyFeetArmor) == true
            @partyFeetArmor = [Option.new("none",->(){})]
        end
        @partyFeetArmor.push(Option.new("Unequip",->(){@party.unequip("feet",@currentPartyMember)}))
        @partyFeetArmor.push(equipBack)
    end
    def update
        @choiceNames = @currentOptions.map{|e|e.text_image}
        @currentChoices =  @currentOptions.map{|e|e.function}
        @choiceAmount = @currentOptions.length
        @equipColors[@currentPartyMember] = @currentEquipColor
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
                mapPartyEquipment()
                @currentChoices[@currentChoiceOp].call()
                mapPartyEquipment()
            end
            
        end
        if @input.keyPressed(InputTrigger::ESCAPE) then #Escape Key
            @input.removeFromStack(@optionsBox.stackName)
            $scene_manager.switch_scene("menu")
        end
        
    end
    def draw
        #Draw Party Info 
        @partyNames = @party.party.map{|e|Gosu::Image.from_text(e.name, 25,:underline=>true)}
        @partyHP = @party.party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyLVL = @party.party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}
        
        
        for a in (0...@party.party.length)
            @partyNames[a].draw((7*32), 20+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyLVL[a].draw((7*32), 45+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyHP[a].draw((7*32), 70+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyWeapons[a].draw((7*32), 100+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyShield[a].draw((7*32), 130+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyHead[a].draw((7*32), 155+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyNeck[a].draw((7*32), 180+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyBody[a].draw((7*32), 205+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyHands[a].draw((7*32), 230+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyLegs[a].draw((7*32), 255+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
            @partyFeet[a].draw((7*32), 275+(90*a), 8,scale_x = 1, scale_y = 1, color = @equipColors[@currentPartyMember])
        end

        #draw boxes
        @optionsBox.draw
        create_window(6,0,19,19) 
    end
end