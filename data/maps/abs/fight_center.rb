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
    @actorBattle = bat 
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
        if baddy.is_a?(Event)
            if baddy.battle.hateGroup == e
                return true
            end
        end
        }
        return false
    end
    def inSpellbook(spellsKnown,spellUsed)
        if spellsKnown.is_a?(Array)
            spellsKnown.each{|e|
                if e == spellUsed
                    return true
                end
            }
            return false
        end
    end
    def meleeCooldown()
        if @meleeCool == true
            if ((Gosu::milliseconds - @cooldownTime)) >= @actorBattle.weapon.cooldown
                @cooldownTime = Gosu::milliseconds
                @meleeCool = false
            end
        end
    end

    def magicCoolList()
        if @spellCast != nil
            if @magicCool.length > 0
                @magicCool.each_with_index{|spell,index|
                delayTime = spell.cooldown
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
                if @spellCast.name == spellname
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
    def meleeAnimation(name,dir,object)
        x = object.x
        y = object.y
        w = object.w
        h = object.h
        if name == "slash"
            case dir
            when "up"
                return @skillAnimation.play_animation(name,x-3*32,y-3*32,nil)
            when "down"
                return @skillAnimation.play_animation(name,x-3*32,y-2*32,:vert)
            when "left"
                return @skillAnimation.play_animation(name,x-4*32,y-2*32,nil)
            when "right"
                return @skillAnimation.play_animation(name,x-1.8*32,y-2*32,:horiz)
            end
        elsif name == "blunt"
            case dir
            when "up"
                return @skillAnimation.play_animation(name,x-1*32,y-1.5*32,nil)
            when "down"
                return @skillAnimation.play_animation(name,x-1*32,y+8,:vert)
            when "left"
                return @skillAnimation.play_animation(name,x-2*32,y-2*32,nil)
            when "right"
                return @skillAnimation.play_animation(name,x,y-24,:horiz)
            end
        elsif name == "fire"
            case dir
            when "up"
                return @skillAnimation.play_animation(name,x-2.5*32,y-4*32,nil)
            when "down"
                return @skillAnimation.play_animation(name,x-2.5*32,y+7,:vert)
            when "left"
                return @skillAnimation.play_animation(name,x-4.2*32,y-2*32,nil)
            when "right"
                return @skillAnimation.play_animation(name,x-0.5*32,y-2.5*32,:horiz)
            end
        end
    end
    
    def closeCombat(objectToMove, battle,facing,wpnAnimation="slash") # The Actual Melee Attack triggering
        if  @meleeCool == false
            wpnAnimation = battle.weapon.animation
            
            case facing
            when "left"
                meleeAnimation(wpnAnimation,facing,objectToMove)
                meleeAttack(objectToMove,battle,facing,(objectToMove.w+32+battle.weapon.range))
            when "right"
                meleeAnimation(wpnAnimation,facing,objectToMove)
                meleeAttack(objectToMove,battle,facing,objectToMove.w+32+battle.weapon.range)
            when "up"
                meleeAnimation(wpnAnimation,facing,objectToMove)
                meleeAttack(objectToMove,battle,facing,objectToMove.h+32+battle.weapon.range)
            when "down"
                meleeAnimation(wpnAnimation,facing,objectToMove)
                meleeAttack(objectToMove,battle,facing,objectToMove.h+32+battle.weapon.range)
            end
            @meleeCool = true
        end
    end
    def rangedCombat(objectToMove,facing,spellUsed,battle) # The Actual Ranged Attack triggering
        if onMagicCoolList(spellUsed) == false
            if inSpellbook(battle.knownSpells,spellUsed) == true
                @magicAttack = MagicBook.new(battle.int)
                @spellCast = @magicAttack.spellList.spell(spellUsed)
                #@lastSpell = @spellCast[5]
                @magicCool.push(@spellCast)
                @magicAttack.ranged_shot(objectToMove,facing,spellUsed)
            end
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

    def npcAttack(objectToMove,battle,facing,type="auto")
        
        case type
        when "melee"
            if isAnEnemy(theEnemyMelee,battle) == true
                closeCombat(objectToMove, battle,facing,battle.weapon.animation)
            end
        when "ranged"
            if isAnEnemy(theEnemyRanged,battle) == true
                rangedCombat(objectToMove,facing,battle.currentSpell.name,battle)
            end
        when "auto"
            meleeRange = battle.weapon.range
            if battle.currentSpell.is_a?(Magic) == true
                spellRange = battle.currentSpell.range
            else
                spellRange = 0
            end
            theEnemyMelee = MoveCollision.new.check_inRange(objectToMove,meleeRange,true)
            theEnemyRanged = MoveCollision.new.check_inRange(objectToMove,spellRange,true)
            if theEnemyMelee.is_a?(Event) == true
                if isAnEnemy(theEnemyMelee,battle) == true
                    closeCombat(objectToMove, battle,facing,battle.weapon.animation)
                end
            elsif theEnemyRanged.is_a?(Event) == true
                if isAnEnemy(theEnemyRanged,battle) == true
                    rangedCombat(objectToMove,facing,battle.currentSpell.name,battle)
                end
            end
        end
    end
    def eventAtkChoice(objectToMove, battle,facing ,detectDist,objectToFollow,atkType)
        objCollision = MoveCollision.new
        
        if objectToFollow.is_a?(GameObject)
            meleeRange = battle.weapon.range
            if battle.currentSpell.is_a?(Magic) == true
                spellRange = battle.currentSpell.range
            else
                spellRange = 0
            end
            if meleeRange > spellRange
                closestDist = meleeRange
            elsif meleeRange < spellRange
                closestDist = spellRange
            else
                closestDist = 32
            end
            #if objectToFollow.x != objectToMove.x && objectToFollow.y != objectToMove.y
                if (objectToFollow.x - objectToMove.x ).abs <= detectDist && (objectToFollow.y - objectToMove.y ).abs <= detectDist # outer ring
                    if (objectToFollow.x - objectToMove.x ).abs <= closestDist && (objectToFollow.y - objectToMove.y ).abs <= closestDist #inner ring
                        if objCollision.check_inRange(objectToMove,closestDist,false) == true #checks if is in total range
                            case facing
                            when "up"
                                if objCollision.checkRange(objectToMove,"up",closestDist) == true && (objectToFollow.x - objectToMove.x ).abs < 33
                                    npcAttack(objectToMove, battle,facing,atkType)
                                end
                            when "down"
                                if objCollision.checkRange(objectToMove,"down",closestDist) == true && (objectToFollow.x - objectToMove.x ).abs < 33
                                    npcAttack(objectToMove, battle,facing,atkType)
                                end
                            when "left"
                                if objCollision.checkRange(objectToMove,"left",closestDist) == true && (objectToFollow.y - objectToMove.y ).abs < 33
                                    npcAttack(objectToMove, battle,facing,atkType)
                                end
                            when "right"
                                if objCollision.checkRange(objectToMove,"right",closestDist) == true && (objectToFollow.y - objectToMove.y ).abs < 33
                                    npcAttack(objectToMove, battle,facing,atkType)
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
        @skillAnimation.update
        if @magicAttack.is_a?(MagicBook)
            @magicAttack.update
        end

        magicCoolList()
        meleeCooldown()
    end
    def draw
        @skillAnimation.draw
        if @magicAttack.is_a?(MagicBook)
            @magicAttack.draw
        end
    end
end
