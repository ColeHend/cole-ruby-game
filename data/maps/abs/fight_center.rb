require_relative "../events/move_collision.rb"
require_relative "../../files/play_animation.rb"
require_relative "../characters/magic/magic_attack.rb"
class FightCenter
    def initialize(name,bat,cooldownTimer=Gosu::milliseconds())
    # damage = ((wpnDMG*STR)/armor)
    # mDMG = (mDMG*INT)/mRes+2
    @name = name
    @collisionDetect = MoveCollision.new(name)
    @skillAnimation = PlayAnimation.new()
    @magicAttack 
    @showDamage = true
    @meleeCool = false
    @cooldownTime = cooldownTimer
    @spellCast = nil
    @magicCool = Array.new()
    @lastSpell
    end

    def damage_calc(wpnDMG,str=2,armor=10)
        damage = ((wpnDMG*str)/armor+2)
        return damage
    end
    def magicDamage_calc(mDMG,int,mRes)
        magicDamage = (mDMG*int)/mRes+2
        return magicDamage
    end
    def isAnEnemy(baddy,goody)
        goody.enemyGroups.each {|e|
        if baddy.battle.hateGroup == e
            return true
        end
        
        }
        return false
    end
    
    def meleeCooldown(cooldownTime=350)
        if @meleeCool == true
            if ((Gosu::milliseconds - @cooldownTime)) >= cooldownTime
                @cooldownTime = Gosu::milliseconds
                @meleeCool = false
            end
        end
    end

    def magicCoolList()
        if @spellCast != nil
            if @magicCool.length > 0
                @magicCool.each_with_index{|spell,index|
                delayTime = spell[4]
                #currentTime = delayTime - (Gosu::milliseconds - @cooldownTime)
                if ((Gosu::milliseconds - @cooldownTime)) >= delayTime
                    currentTime = delayTime
                    @cooldownTime = Gosu::milliseconds
                    @magicCool.delete_at(index)
                    @spellCast = nil
                end
                }
            end
        end
    end
    def onMagicCoolList(spellname)
        if @magicCool.length > 0
            @magicCool.each {|spell|
                if @spellCast[5] == spellname
                    return true
                end
            }
        end
        return false
    end

    def meleeAttack(attackerObj,attacker,facing,rangeBoost=0) # The Melee Attack Removing the enemies hp
        #@collisionDetect.checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        @collisionDetect = MoveCollision.new(@name)
        if @collisionDetect.checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = @collisionDetect.checkDir(attackerObj,"up",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
                defender.currentHP -= damage
                if @showDamage == true
                    puts("-------------Melee-----------------")
                    puts("attacker: #{attacker.name}")
                    puts("beingAttacked: #{defender.name}")
                    puts("weaponDmg: #{attacker.weapon.damage}")
                    puts("damage: #{damage}")
                    puts("armor: #{defender.totalArmor}")
                    puts("defenderAfterHP: #{defender.currentHP}")
                    puts("-------------------------------")
                end
            end
        end
        if @collisionDetect.checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = @collisionDetect.checkDir(attackerObj,"down",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
                defender.currentHP -= damage
                if @showDamage == true
                    puts("-------------Melee-----------------")
                    puts("attacker: #{attacker.name}")
                    puts("beingAttacked: #{defender.name}")
                    puts("weaponDmg: #{attacker.weapon.damage}")
                    puts("damage: #{damage}")
                    puts("armor: #{defender.totalArmor}")
                    puts("defenderAfterHP: #{defender.currentHP}")
                    puts("-------------------------------")
                end
            end
        end
        if @collisionDetect.checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = @collisionDetect.checkDir(attackerObj,"left",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
                defender.currentHP -= damage
                if @showDamage == true
                    puts("-------------Melee-----------------")
                    puts("attacker: #{attacker.name}")
                    puts("beingAttacked: #{defender.name}")
                    puts("weaponDmg: #{attacker.weapon.damage}")
                    puts("damage: #{damage}")
                    puts("armor: #{defender.totalArmor}")
                    puts("defenderAfterHP: #{defender.currentHP}")
                    puts("-------------------------------")
                end
            end
        end
        if @collisionDetect.checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = @collisionDetect.checkDir(attackerObj,"right",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
                defender.currentHP -= damage
                if @showDamage == true
                    puts("-------------Melee-----------------")
                    puts("attacker: #{attacker.name}")
                    puts("beingAttacked: #{defender.name}")
                    puts("weaponDmg: #{attacker.weapon.damage}")
                    puts("damage: #{damage}")
                    puts("armor: #{defender.totalArmor}")
                    puts("defenderAfterHP: #{defender.currentHP}")
                    puts("-------------------------------")
                end
            end
        end
        
    end

    
    def closeCombat(objectToMove, battle,facing,wpnAnimation="slash") # The Actual Melee Attack triggering
        if  @meleeCool == false
            case facing
            when "left"
                @skillAnimation.play_animation(wpnAnimation,objectToMove.x-4*32,objectToMove.y-2*32,nil)
                meleeAttack(objectToMove,battle,facing,32)
                puts("attack")
            when "right"
                @skillAnimation.play_animation(wpnAnimation,objectToMove.x-1.8*32,objectToMove.y-2.1*32,:horiz)
                meleeAttack(objectToMove,battle,facing,32)
                puts("attack")
            when "up"
                @skillAnimation.play_animation(wpnAnimation,objectToMove.x-3*32,objectToMove.y-3*32,nil)
                meleeAttack(objectToMove,battle,facing,32)
                puts("attack")
            when "down"
                @skillAnimation.play_animation(wpnAnimation,objectToMove.x-3*32,objectToMove.y-2*32,:vert)
                meleeAttack(objectToMove,battle,facing,32)
                puts("attack")
            end
            @meleeCool = true
        end
    end
    def rangedCombat(objectToMove,facing,spellUsed="firebolt",bat) # The Actual Ranged Attack triggering
        if onMagicCoolList(spellUsed) == false
            @magicAttack = MagicBook.new(bat.int)
            @spellCast = @magicAttack.spellList.spell(spellUsed)
            #@lastSpell = @spellCast[5]
            @magicCool.push(@spellCast)
            @magicAttack.ranged_shot(objectToMove,facing,spellUsed)
            
        end
    end

    def eventBattleTarget(allTargets,theFighter)
        enemyTargets = Array.new
        allTargets.each {|target|
            if isAnEnemy(target,theFighter) == true
                enemyTargets.push(target)
            end
        }
        case enemyTargets.length
        when 0
            return nil
        when 1
            return enemyTargets[0]
        else
            if enemyTargets.length > 1
                return enemyTargets[0]
            else
                return nil
            end
        end
    end
    def npcAttack(objectToMove, battle,facing ,closestDist,atkRange)
        theEnemy = MoveCollision.new.check_inRange(objectToMove,closestDist,true)
        if theEnemy.is_a?(Event) 
            if isAnEnemy(theEnemy,battle) == true #attacks inside here
                if atkRange == "melee"
                    closeCombat(objectToMove, battle,facing,"slash")
                elsif atkRange == "ranged"
                    rangedCombat(objectToMove,facing,"firebolt",battle)
                else
                end
            end
        end
    end
    def eventAtkChoice(objectToMove, battle,facing ,detectDist,closestDist,atkRange="ranged",objectToFollow)
        objCollision = MoveCollision.new
        
        if objectToFollow.is_a?(GameObject)
            #if objectToFollow.x != objectToMove.x && objectToFollow.y != objectToMove.y
                if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist # outer ring
                    if (objectToFollow.x - objectToMove.x ).abs <= closestDist && (objectToFollow.y - objectToMove.y ).abs <= closestDist #inner ring
                        if objCollision.check_inRange(objectToMove,closestDist,false) == true #checks if is in total range
                            case facing
                            when "up"
                                if objCollision.checkRange(objectToMove,"up",closestDist) == true
                                    if (objectToMove.y - objectToFollow.y).abs < closestDist
                                        npcAttack(objectToMove, battle,facing ,closestDist,atkRange)
                                    end
                                end
                            when "down"
                                if objCollision.checkRange(objectToMove,"down",closestDist) == true
                                    if (objectToMove.y - objectToFollow.y).abs < closestDist
                                        npcAttack(objectToMove, battle,facing ,closestDist,atkRange)
                                    end
                                end
                            when "left"
                                if objCollision.checkRange(objectToMove,"left",closestDist) == true
                                    if (objectToMove.x - objectToFollow.x).abs < closestDist
                                        npcAttack(objectToMove, battle,facing ,closestDist,atkRange)
                                    end
                                end
                            when "right"
                                if objCollision.checkRange(objectToMove,"right",closestDist) == true
                                    if (objectToMove.x - objectToFollow.x).abs < closestDist
                                        npcAttack(objectToMove, battle,facing ,closestDist,atkRange)
                                    end
                                end
                            end
                        end
                    end
                end
            #end
        elsif objectToFollow.is_a?(GameObject) == false
            if objCollision.check_inRange(objectToMove,detectDist ,false) == true
                theEnemy = objCollision.check_inRange(objectToMove,detectDist,true)
                if theEnemy.is_a?(Event)
                    if isAnEnemy(theEnemy,battle)
                        if objectToMove.x != theEnemy.x && objectToMove.y != theEnemy.y
                            objectToFollow = theEnemy.eventObject
                        end
                    end
                end
            end
        end
    end

    def update
        @cooldownTimer

        if @magicAttack != nil
            @magicAttack.update
        elsif @skillAnimation != nil
            @skillAnimation.update
        end

        magicCoolList()
        meleeCooldown(350)
    end
    def draw
        if @magicAttack != nil
            @magicAttack.draw
        elsif @skillAnimation != nil
            @skillAnimation.draw
        end
    end
end
