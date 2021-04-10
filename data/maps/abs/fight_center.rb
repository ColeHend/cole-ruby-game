require_relative "../events/move_collision.rb"
require_relative "../../files/play_animation.rb"
require_relative "../characters/magic/magic_attack.rb"
class FightCenter
    def initialize(name,bat)
    # damage = ((wpnDMG*STR)/armor)
    # mDMG = (mDMG*INT)/mRes+2
    @collisionDetect = MoveCollision.new(name)
    @skillAnimation
    @magicAttack 
    @showDamage = true
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

    def meleeAttack(attackerObj,attacker,facing,rangeBoost=0) # The Melee Attack Removing the enemies hp
        #@collisionDetect.checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        
        if @collisionDetect.checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = @collisionDetect.checkDir(attackerObj,"up",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
                defender.currentHP -= damage
                if @showDamage == true
                    puts("-------------#{defender.name}-----------------")
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
                    puts("-------------#{defender.name}-----------------")
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
                    puts("-------------#{defender.name}-----------------")
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
                    puts("-------------#{defender.name}-----------------")
                    puts("damage: #{damage}")
                    puts("armor: #{defender.totalArmor}")
                    puts("defenderAfterHP: #{defender.currentHP}")
                    puts("-------------------------------")
                end
            end
        end
        
    end

    def magicAttack(attackerObj,attacker,facing,rangeBoost) # The Ranged Attack Removing the enemies hp

        if @collisionDetect.checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = @collisionDetect.checkDir(attackerObj,"up",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
                defender.currentHP -= damage
            end
        end
        if @collisionDetect.checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = @collisionDetect.checkDir(attackerObj,"down",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
                defender.currentHP -= damage
            end
        end
        if @collisionDetect.checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = @collisionDetect.checkDir(attackerObj,"left",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
                defender.currentHP -= damage
            end
        end
        if @collisionDetect.checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = @collisionDetect.checkDir(attackerObj,"right",rangeBoost,true)
            if isAnEnemy(defender,attacker) == true
                defender = defender.battle
                damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
                defender.currentHP -= damage
            end
        end
        if @showDamage == true
            puts("-----magic--------#{defender.name}-----------------")
            puts("damage: #{damage}")
            puts("armor: #{defender.totalArmor}")
            puts("defenderBeforeHP: #{defender.currentHP}")
            puts("-------------------------------")
        end
    end
    def closeCombat(objectToMove, battle,facing,wpnAnimation="slash") # The Actual Melee Attack triggering
        @skillAnimation = PlayAnimation.new
        case facing
        when "left"
            @skillAnimation.play_animation(wpnAnimation,objectToMove.x-4*32,objectToMove.y-2*32,nil)
            meleeAttack(objectToMove,battle,facing,32)
        when "right"
            @skillAnimation.play_animation(wpnAnimation,objectToMove.x-1.8*32,objectToMove.y-2.1*32,:horiz)
            meleeAttack(objectToMove,battle,facing,32)
        when "up"
            @skillAnimation.play_animation(wpnAnimation,objectToMove.x-3*32,objectToMove.y-3*32,nil)
            meleeAttack(objectToMove,battle,facing,32)
        when "down"
            @skillAnimation.play_animation(wpnAnimation,objectToMove.x-3*32,objectToMove.y-2*32,:vert)
            meleeAttack(objectToMove,battle,facing,32)
        end
    end
    def rangedCombat(objectToMove,facing,spellUsed="firebolt",bat) # The Actual Ranged Attack triggering
        @magicAttack = MagicBook.new(bat.int)
        @magicAttack.ranged_shot(objectToMove,facing,spellUsed)
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
    def eventAtkChoice(objectToMove, battle,facing ,detectRange,actionRange,atkRange="ranged",objectToFollow)
        detectDist = detectRange
        closestDist = actionRange
        if objectToFollow != nil
            #if objectToFollow.x != objectToMove.x && objectToFollow.y != objectToMove.y
                if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist # outer ring
                    if (objectToFollow.x - objectToMove.x ).abs <= closestDist && (objectToFollow.y - objectToMove.y ).abs <= closestDist #inner ring
                        if MoveCollision.new.check_collision(objectToMove,closestDist,false) == true #needs to check if colliding with an object
                            theEnemy = MoveCollision.new.check_collision(objectToMove,closestDist,true)
                            if isAnEnemy(theEnemy,battle) == true
                                if atkRange == "melee"
                                    closeCombat(objectToMove, battle,facing,"slash")
                                elsif atkRange == "ranged"
                                    rangedCombat(objectToMove,facing,"firebolt",battle)
                                else
                                end
                            end
                        end
                    end
                end
            #end
        end
    end

    def update
        if @magicAttack != nil
            @magicAttack.update
        elsif @skillAnimation != nil
            @skillAnimation.update
        end
    end
    def draw
        if @magicAttack != nil
            @magicAttack.draw
        elsif @skillAnimation != nil
            @skillAnimation.draw
        end
    end
end
