
local Weapon = Class(function(self, inst)
    self.inst = inst
    self.damage = 10
    self.attackrange = nil
    self.hitrange = nil
    self.onattack = nil
    self.onprojectilelaunch = nil
    self.canattack = nil
    self.projectile = nil
    self.stimuli = nil
    self.projectilelaunchsymbol = nil 

    --Monkey uses these
    self.modes = 
    {
        MODE1 = {damage = 0, ranged = false, attackrange = 0, hitrange = 0},
    --etc.
    }
    self.variedmodefn = nil
end)

function Weapon:SetDamage(dmg)
    self.damage = dmg
end

function Weapon:SetRange(attack, hit)
    self.attackrange = attack
    self.hitrange = hit or self.attackrange
end

function Weapon:SetOnAttack(fn)
    self.onattack = fn
end

function Weapon:SetOnProjectileLaunch(fn)
    self.onprojectilelaunch = fn
end

function Weapon:SetCanAttack(fn)
    self.canattack = fn
end

function Weapon:SetProjectile(projectile)
    self.projectile = projectile
end

function Weapon:SetElectric()
    self.stimuli = "electric"
end

function Weapon:CanRangedAttack()
    if self.variedmodefn then
        local mode = self.variedmodefn(self.inst)
        if not mode.ranged then
            --determined to use melee mode, return false.
            return false
        end
    end

    return self.projectile ~= nil
end

function Weapon:SetAttackCallback(fn)
    self.onattack = fn
end

function Weapon:OnAttack(attacker, target, projectile)
    if self.onattack then
        self.onattack(self.inst, attacker, target)
    end
    
    if self.inst.components.finiteuses then
	    self.inst.components.finiteuses:Use(self.attackwear or 1)
    end
end

function Weapon:LaunchProjectile(attacker, target)
	if self.projectile then

        if self.onprojectilelaunch then
            self.onprojectilelaunch(self.inst, attacker, target)
        end

	    local proj = SpawnPrefab(self.projectile)
	    if proj and proj.components.projectile then
            local owner = nil 
            if self.inst.components.inventoryitem then 
                  owner = self.inst.components.inventoryitem.owner
                  if owner and owner.components.inventoryitem and owner.components.inventoryitem.owner then 
                      owner = owner.components.inventoryitem.owner
                  end
            end

            if self.projectilelaunchsymbol and owner and owner.AnimState then 
                proj.Transform:SetPosition(owner.AnimState:GetSymbolPosition(self.projectilelaunchsymbol, 0, 0, 0))
            else
                proj.Transform:SetPosition(attacker.Transform:GetWorldPosition() )
            end
	        proj.components.projectile:Throw(self.inst, target, attacker)
	    end
      if proj and proj.components.complexprojectile then 
          proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
          proj.components.complexprojectile:Launch(target:GetPosition(), attacker, self.inst)                
      end      
	end
end

function Weapon:CollectUseActions(doer, target, actions)
    if self.inst.components.inventoryitem and target.components.container and target.components.container.canbeopened then
    	-- put weapons into chester, don't attack him unless forcing attack with key press
        table.insert(actions, target:HasTag("bundle") and ACTIONS.BUNDLESTORE or ACTIONS.STORE)
    else
	    if doer.components.combat and doer.components.combat:CanTarget(target) 
		   and target.components.combat:CanBeAttacked(doer)
	       and (not self.canattack or self.canattack(self.inst, target) ) then
	       
			local should_light = target.components.burnable and self.inst.components.lighter 
			if not should_light then
				table.insert(actions, ACTIONS.ATTACK)
			end
	    end
    end
end


function Weapon:CollectEquippedActions(doer, target, actions)
    if doer.components.combat 
       and not target:HasTag("wall")
       and doer.components.combat:CanTarget(target)
       and target.components.combat:CanBeAttacked(doer)
       and not doer.components.combat:IsAlly(target)
       and (not self.canattack or self.canattack(self.inst, target) ) 
       and target:HasTag("mole")
       and self.inst:HasTag("hammer") then
        table.insert(actions, ACTIONS.WHACK)
    elseif doer.components.combat
       and self.inst:HasTag("extinguisher")
       and target.components.burnable
       and (target.components.burnable:IsSmoldering() or target.components.burnable:IsBurning()) then
        table.insert(actions, ACTIONS.RANGEDSMOTHER)
    elseif doer.components.combat
       and self.inst:HasTag("rangedlighter")
       and target.components.burnable
       and target.components.burnable.canlight
       and not target.components.burnable:IsBurning() 
       and not target:HasTag("burnt") then
        table.insert(actions, ACTIONS.RANGEDLIGHT)
    elseif doer.components.combat 
	   and not target:HasTag("wall")
       and doer.components.combat:CanTarget(target)
	   and target.components.combat:CanBeAttacked(doer)
       and not doer.components.combat:IsAlly(target)
       and (not self.canattack or self.canattack(self.inst, target) ) then
        table.insert(actions, ACTIONS.ATTACK)
    end
end

return Weapon
