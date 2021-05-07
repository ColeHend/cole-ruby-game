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
        @descriptionType = nil
        #   Options
        back = [Option.new("Back",->(){
            @input.removeFromStack(@optionsBox.stackName)
            $scene_manager.switch_scene("menu")
            @input.addToStack("options")
        })]
        @currentOptions = back
        @optionsBox = OptionsBox.new("Equipment",0,0,4,10,@currentOptions,"")
        
        #   Equipment
        
        @partyNames = @party.party.map{|e|Gosu::Image.from_text(e.name, 25)}
        
        #list of party members
        @startOptions = @party.party.each_with_index.map{|member,index| 
            Option.new(member.name,->(){
                @currentPartyMember = index
                @currentOptions = @equipmentOptions
                @optionsBox.change_options(@equipmentOptions)
                @optionsBox = OptionsBox.new("Equipment",0,0,4,10,@equipmentOptions,"")
            })
        }
        @startOptions.push(back[0])
        mapPartyEquipment()
        @currentOptions = @startOptions
        @optionsBox = OptionsBox.new("Equipment",0,0,4,10,@startOptions,"")
        #equiment options
        #--------------------------
        
        #---- @party.unequip(equipItem,equipSpot)
        @equipmentOptions =  [
            Option.new("Weapon",->(){
                @descriptionType = "weapon"
                @currentOptions = weaponOptions()
                @optionsBox.change_options(weaponOptions())
            }),
            Option.new("Shield",->(){ 
                @descriptionType = "shield"
                @currentOptions = armorOptions("shield")
                @optionsBox.change_options(armorOptions("shield"))
            }),
            Option.new("Head",->(){
                @descriptionType = "helm"
                @currentOptions = armorOptions("helm")
                @optionsBox.change_options(armorOptions("helm"))
            }),
            Option.new("Neck",->(){
                @descriptionType = "neck"
                @currentOptions = armorOptions("neck")
                @optionsBox.change_options(armorOptions("neck"))
            }),
            Option.new("Body",->(){
                @descriptionType = "body"
                @currentOptions = armorOptions("body")
                @optionsBox.change_options(armorOptions("body"))
            }),
            Option.new("Hands",->(){
                @descriptionType = "hands"
                @currentOptions = armorOptions("hands")
                @optionsBox.change_options(armorOptions("hands"))
            }),
            Option.new("Legs",->(){
                @descriptionType = "legs"
                @currentOptions = armorOptions("legs")
                @optionsBox.change_options(armorOptions("legs"))
            }),
            Option.new("Feet",->(){
                @descriptionType = "feet"
                @currentOptions = armorOptions("feet")
                @optionsBox.change_options(armorOptions("feet"))
            }),
            Option.new("Back",->(){
                @descriptionType = nil
                @optionsBox = OptionsBox.new("Equipment",0,0,4,19,@startOptions,"")
        })]
        #change to party options
        

        #   Colors
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @orange = Gosu::Color.argb(0xff_fc5203)
        @brightGreen = Gosu::Color.argb(0xff_2ca81e)
        @notCurrentColor = @white
        @currentColor = @brightGreen
        @currentEquipColor = @white
        @equipColors = Array.new(5,@black)
        
        
        @partyNames = @party.party.map{|e|Gosu::Image.from_text(e.name, 25,:underline=>true)}
        @partyDEX = @party.party.map{|e|Gosu::Image.from_text("Dexterity: "+e.dex.to_s, 18)}
        @partyINT = @party.party.map{|e|Gosu::Image.from_text("Intelligence: "+e.int.to_s, 18)}
        @partyCON = @party.party.map{|e|Gosu::Image.from_text("Constitution: "+e.con.to_s, 18)}
        @partyLVL = @party.party.map{|e|Gosu::Image.from_text("Level: "+e.playerLevel.to_s, 18)}
        @partyXP = @party.party.map{|e|Gosu::Image.from_text("XP: "+e.exp.to_s, 18)}

        #   Armor 
        #
        @currentArmorOp = 0 
        
        @colors = Array.new(40,@notCurrentColor)
        @colors[0] = @currentColor
    end
    def amountIsNone(equipment) # return if an array is empty
        if equipment != nil
            if equipment.length > 0 && equipment[0] != 666
                return false
            else 
                return true
            end
        end
    end
    def armorArray(arrayType) #Types Are : "helm","shield","neck", "body", "hands", "legs", "feet"
        array = Array.new
        @party.inventory.armor.each{|e|
        if e.is_a?(Armor) == true
            if e.type == arrayType
                array.push(e)
            end
        end
        }
        return array
    end
    def weaponOptions()
        array = Array.new
        array = @party.inventory.weapons.each.map{|e|
        if e.is_a?(Weapon) == true
            Option.new(e.name,->(){ #Actual weapon option
                @party.equip(e,@currentPartyMember)
                
                @currentOptions = @equipmentOptions
                @optionsBox.change_options(@equipmentOptions)
            })
        end
        }
        if amountIsNone(array) == true
            array = [Option.new("none",->(){})]
        end
        #array.push(Option.new("Unequip",->(){@party.unequip("weapon",@currentPartyMember)}))
        array.push(Option.new("Back",->(){
            @descriptionType = nil
            @currentOptions = @equipmentOptions
            @optionsBox.change_options(@equipmentOptions)
        }))
        return array
    end
    def armorOptions(type)
        array = Array.new
        array = armorArray(type).each.map{|e| #
            if e.is_a?(Armor)
                Option.new(e.name,->(){ #actual armor option
                    @party.equip(e,@currentPartyMember)
                    @currentOptions = @equipmentOptions
                    @optionsBox.change_options(@equipmentOptions)
                })
            end
        }
        if amountIsNone(array) == true
            array = [Option.new("none",->(){})]
        end
        array.push(Option.new("Unequip",->(){@party.unequip(type,@currentPartyMember)}))
        array.push(Option.new("Back",->(){
            @descriptionType = nil
            @currentOptions = @equipmentOptions
            @optionsBox.change_options(@equipmentOptions)
        }))
        puts(array[0].text)
        return array
    end
    #----
    def armorDescript(type)
        array = armorArray(type).each.map{|e| 
            if e.is_a?(Armor)
                Gosu::Image.from_text(e.name.to_s+": "+e.description.to_s, 18)
            end
        }
        return array
    end
    def mapPartyEquipment()
        @partyWeapons = @party.party.map{|e|
        if e.weapon.is_a?(Weapon)
            Gosu::Image.from_text("Weapon: #{e.weapon.name}", 18)
        else
            Gosu::Image.from_text("Weapon: None", 18)
        end
        }
        @partyShield = @party.party.map{|e|
        if e.shield.is_a?(Armor)
            Gosu::Image.from_text("Shield: #{e.shield.name}", 18)
        else
            Gosu::Image.from_text("Shield: None", 18)
        end
        }
        @partyHead = @party.party.map{|e|
        if e.helm.is_a?(Armor)
            Gosu::Image.from_text("Head: #{e.helm.name}", 18)
        else
            Gosu::Image.from_text("Head: None", 18)
        end
        }
        @partyNeck = @party.party.map{|e|
        if e.necklace.is_a?(Armor)
            Gosu::Image.from_text("Neck: #{e.necklace.name}", 18)
        else
            Gosu::Image.from_text("Neck: None", 18)
        end
        }
        @partyBody = @party.party.map{|e|
        if e.chest.is_a?(Armor)
            Gosu::Image.from_text("Body: #{e.chest.name}", 18)
        else
            Gosu::Image.from_text("Body: None", 18)
        end
        }
        @partyHands = @party.party.map{|e|
        if e.hands.is_a?(Armor)
            Gosu::Image.from_text("Hands: #{e.hands.name}", 18)
        else
            Gosu::Image.from_text("Hands: None", 18)
        end
        }    
        @partyLegs = @party.party.map{|e|
        if e.legs.is_a?(Armor)
            Gosu::Image.from_text("Legs: #{e.legs.name}", 18)
        else
            Gosu::Image.from_text("Legs: None", 18)
        end
        }
        @partyFeet = @party.party.map{|e|
        if e.feet.is_a?(Armor)
            Gosu::Image.from_text("Feet: #{e.feet.name}", 18)
        else
            Gosu::Image.from_text("Feet: None", 18)
        end
        }
        
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
        if @descriptionType != nil
            
            @partyWeaponDescription = @party.inventory.weapons.map{|e|Gosu::Image.from_text(e.name.to_s+": "+e.description.to_s, 18)}
            descriptionDraw = armorDescript(@descriptionType)
        end
        #Draw Party Info 
        @partyHP = @party.party.map{|e|Gosu::Image.from_text("HP: "+e.currentHP.to_s+"/"+e.hp.to_s, 18)}
        @partyAC = @party.party.map{|e|Gosu::Image.from_text("Armor: "+e.total_ac(0).to_s, 18)}
        @partySTR = @party.party.map{|e|Gosu::Image.from_text("Strength: "+e.str.to_s, 18)}
        @partyWPNDMG = @party.party.map{|e|Gosu::Image.from_text("Weapon Damage: "+(e.weapon.damage*(@party.party[@currentPartyMember].getMod(@party.party[@currentPartyMember].str))).to_s, 18)}
        @partyMRES = @party.party.map{|e|Gosu::Image.from_text("Magic Resistance: "+e.mRes.to_s, 18)}
        
        
        mapPartyEquipment()
        
        #draw boxes
        @optionsBox.draw
        create_window(5.25,0,19,13.5)
        create_window(5.25,14.25,19,4)

        if @descriptionType != nil && descriptionDraw[@currentChoiceOp] != nil && @descriptionType != "weapon"
            descriptionDraw[@currentChoiceOp].draw((6*32),(15*32), 8,scale_x = 1, scale_y = 1, color = @white)
        end
        if @descriptionType == "weapon" && @partyWeaponDescription[@currentChoiceOp] != nil
            @partyWeaponDescription[@currentChoiceOp].draw((6*32),(15*32), 8,scale_x = 1, scale_y = 1, color = @white)
        end
        #left column
        @partyNames[@currentPartyMember].draw((7*32), 20, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyLVL[@currentPartyMember].draw((7*32), 45, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyHP[@currentPartyMember].draw((7*32), 70, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyWeapons[@currentPartyMember].draw((7*32), 100, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyShield[@currentPartyMember].draw((7*32), 130, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyHead[@currentPartyMember].draw((7*32), 155, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyNeck[@currentPartyMember].draw((7*32), 180, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyBody[@currentPartyMember].draw((7*32), 205, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyHands[@currentPartyMember].draw((7*32), 230, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyLegs[@currentPartyMember].draw((7*32), 255, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyFeet[@currentPartyMember].draw((7*32), 280, 8,scale_x = 1, scale_y = 1, color = @white)
        #right column
        @partyWPNDMG[@currentPartyMember].draw((14*32), 45, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyAC[@currentPartyMember].draw((14*32), 70, 8,scale_x = 1, scale_y = 1, color = @white)
        @partySTR[@currentPartyMember].draw((14*32), 95, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyDEX[@currentPartyMember].draw((14*32), 120, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyINT[@currentPartyMember].draw((14*32), 145, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyCON[@currentPartyMember].draw((14*32), 170, 8,scale_x = 1, scale_y = 1, color = @white)
        @partyMRES[@currentPartyMember].draw((14*32), 195, 8,scale_x = 1, scale_y = 1, color = @white)
        

         
    end
end