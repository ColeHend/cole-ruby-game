require_relative "../events/move_collision.rb"
include MoveCollision
class FightCenter
    def initialize()
    # damage = ((wpnDMG*STR)/armor)
    # mDMG = (mDMG*INT)/mRes+2
    end

    def damage_calc(wpnDMG,str=2,armor=10)
        damage = ((wpnDMG*str)/armor)
        return damage
    end
    def magicDamage_calc(mDMG,int,mRes)
        magicDamage = (mDMG*int)/mRes+2
        return magicDamage
    end
    
    def meleeAttack(attackerObj,attacker,facing,rangeBoost=0)
        #checkDir(targetObject,dir,rangeBoost=0,evtReturn = false)
        if checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = checkDir(attackerObj,"up",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            puts("-------------up-----------------")
            puts("damage: #{damage}")
            puts("wpnDmg: #{attacker.weapon.damage}")
            puts("modif: #{attacker.getMod(attacker.str)}")
            puts("armor: #{defender.totalArmor}")
            puts("defenderBeforeHP: #{defender.currentHP}")
            defender.currentHP -= damage
            puts("defenderAfterHP: #{defender.currentHP}")
            puts("-------------------------------")
        end
        if checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = checkDir(attackerObj,"down",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        if checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = checkDir(attackerObj,"left",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        if checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = checkDir(attackerObj,"right",rangeBoost,true)
            defender = defender.battle
            damage = damage_calc(attacker.weapon.damage,attacker.getMod(attacker.str),defender.totalArmor)
            defender.currentHP -= damage
        end
        
    end

    def magicAttack(attackerObj,attacker,facing,rangeBoost)
        if checkDir(attackerObj,"up",rangeBoost) == true && facing == "up"
            defender = checkDir(attackerObj,"up",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            puts("-------------up-----------------")
            puts("damage: #{damage}")
            puts("wpnDmg: #{attacker.weapon.damage}")
            puts("modif: #{attacker.getMod(attacker.int)}")
            puts("armor: #{defender.totalArmor}")
            puts("defenderBeforeHP: #{defender.currentHP}")
            defender.currentHP -= damage
            puts("defenderAfterHP: #{defender.currentHP}")
            puts("-------------------------------")
        end
        if checkDir(attackerObj,"down",rangeBoost) == true && facing == "down"
            defender = checkDir(attackerObj,"down",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end
        if checkDir(attackerObj,"left",rangeBoost) == true && facing == "left"
            defender = checkDir(attackerObj,"left",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end
        if checkDir(attackerObj,"right",rangeBoost) == true && facing == "right"
            defender = checkDir(attackerObj,"right",rangeBoost,true)
            defender = defender.battle
            damage = magicDamage_calc(attacker.weapon.damage,attacker.getMod(attacker.int),0)
            defender.currentHP -= damage
        end

    def update
    end
    def draw
    end
end
