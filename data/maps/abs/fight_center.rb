require_relative "../events/move_collision.rb"
class FightCenter
    def initialize(name="fightCenter")
    # damage = ((wpnDMG*STR)/armor)
    # mDMG = (mDMG*INT)/mRes+2
    @collisionDetect = MoveCollision.new(name)
    end

    def damage_calc(wpnDMG,str=2,armor=10)
        damage = ((wpnDMG*str)/armor+2)
        return damage
    end
    def magicDamage_calc(mDMG,int,mRes)
        magicDamage = (mDMG*int)/mRes+2
        return magicDamage
    end
    
    def meleeAttack(attackerObj,attacker,facing,rangeBoost=0)
        #@collisionDetect.checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        if @collisionDetect.checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = @collisionDetect.checkDir(attackerObj,"up",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            puts("-------------#{defender.name}-----------------")
            puts("damage: #{damage}")
            puts("armor: #{defender.totalArmor}")
            puts("defenderBeforeHP: #{defender.currentHP}")
            defender.currentHP -= damage
            puts("defenderAfterHP: #{defender.currentHP}")
            puts("-------------------------------")
        end
        if @collisionDetect.checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = @collisionDetect.checkDir(attackerObj,"down",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        if @collisionDetect.checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = @collisionDetect.checkDir(attackerObj,"left",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        if @collisionDetect.checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = @collisionDetect.checkDir(attackerObj,"right",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        
    end

    def magicAttack(attackerObj,attacker,facing,rangeBoost)

        if @collisionDetect.checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = @collisionDetect.checkDir(attackerObj,"up",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            puts("-----magic--------#{defender.name}-----------------")
            puts("damage: #{damage}")
            puts("armor: #{defender.totalArmor}")
            puts("defenderBeforeHP: #{defender.currentHP}")
            defender.currentHP -= damage
            puts("defenderAfterHP: #{defender.currentHP}")
            puts("-------------------------------")
        end
        if @collisionDetect.checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = @collisionDetect.checkDir(attackerObj,"down",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end
        if @collisionDetect.checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = @collisionDetect.checkDir(attackerObj,"left",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end
        if @collisionDetect.checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = @collisionDetect.checkDir(attackerObj,"right",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end
    end

    def update
    end
    def draw
    end
end
