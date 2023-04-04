local brain = require "brains/tallbirdbrain"
require "stategraphs/SGtallbird"

local assets=
{
	Asset("ANIM", "anim/ds_tallbird_basic.zip"),
	Asset("SOUND", "sound/tallbird.fsb"),
}
    
    
local prefabs =
{
    "meat",
}

local loot = { "meat", "meat" }
local MAX_CHASEAWAY_DIST = 32
local MAX_CHASE_DIST = 256

local function SpringMod(amt)
    if GetSeasonManager() and (GetSeasonManager():IsSpring() or GetSeasonManager():IsGreenSeason()) then
        return amt * TUNING.SPRING_COMBAT_MOD
    else
        return amt
    end
end

local function FindThreatToNest(inst)
    local notags = {"FX", "NOCLICK","INLIMBO", "tallbird", "springbird", "aquatic"}
    local yestags = {"character", "animal", "monster"}
    if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
        return FindEntity(inst.components.homeseeker.home, SpringMod(TUNING.TALLBIRD_DEFEND_DIST), function(guy)
            return guy.components.health
                and not guy.components.health:IsDead()
                and inst.components.combat:CanTarget(guy)
        end, nil, notags, yestags)
    end
end

local function Retarget(inst)
    local newtarget = FindThreatToNest(inst)
    
    if not newtarget then
        local notags = {"FX", "NOCLICK","INLIMBO", "aquatic", "werepig"}
        local yestags = {"pig"}
        newtarget = FindEntity(inst, SpringMod(TUNING.TALLBIRD_TARGET_DIST), function(guy)
            return guy.components.health
                   and not guy.components.health:IsDead()
                   and inst.components.combat:CanTarget(guy)
        end, yestags, notags)
    end

    if not newtarget then
        local notags = {"FX", "NOCLICK","INLIMBO", "aquatic", "tallbird", "springbird", "aquatic"}
        local yestags = {"character", "monster"}
        newtarget = FindEntity(inst, SpringMod(TUNING.TALLBIRD_TARGET_DIST), function(guy)
            return  guy.components.health
                and not guy.components.health:IsDead()
                and inst.components.combat:CanTarget(guy)
        end, nil, notags, yestags)
    end

    return newtarget
end

local function KeepTarget(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if target:HasTag("aquatic") then 
        return false 
    end 

    if home and home.components.pickable then
        if not home.components.pickable:CanBePicked() and target == home.thief then
            return distsq(Vector3(home.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < SpringMod(MAX_CHASE_DIST*MAX_CHASE_DIST)
        else
            return distsq(Vector3(home.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < SpringMod(MAX_CHASEAWAY_DIST*MAX_CHASEAWAY_DIST)
        end
    else
        return true
    end
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not FindThreatToNest(inst)
end

local function ShouldWake(inst)
    return DefaultWakeTest(inst) or FindThreatToNest(inst)
end

local function OnAttacked(inst, data)
    inst.components.combat:SuggestTarget(data.attacker)
end

local MAKE_NEST_EXCLUDE_TAGS = {"tallbird", "FX", "NOCLICK", "DECOR", "INLIMBO", "NOBLOCK"}
local MAKE_NEST_VALID_TILES = {GROUND.ROCKY, GROUND.DIRT, GROUND.MAGMAFIELD}

local function CanMakeNewHome(inst)
	if inst.components.homeseeker == nil and not inst.components.combat:HasTarget() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile = GetWorld().Map:GetTileAtPoint(x, y, z)
		return table.contains(MAKE_NEST_VALID_TILES, tile) and #TheSim:FindEntities(x, y, z, TUNING.TALLBIRD_MAKE_NEST_RADIUS, nil, MAKE_NEST_EXCLUDE_TAGS) == 0
	end
end

local function MakeNewHome(inst)
	if inst:CanMakeNewHome() then
		local nest = SpawnPrefab("tallbirdnest")
		nest.Transform:SetPosition(inst.Transform:GetWorldPosition())
		nest.components.pickable:MakeEmpty()
		nest.components.childspawner:TakeOwnership(inst)
		nest.components.childspawner:SetMaxChildren(1)
		nest:StartNesting()
		return true
	end
end

local function OnEntitySleep(inst, data)
    inst.entitysleeping = true
    if inst.pending_spawn_smallbird then
        local smallbird = SpawnPrefab("smallbird")
        smallbird:PushEvent("SetUpSpringSmallBird", {smallbird=smallbird, tallbird=inst})
        inst.pending_spawn_smallbird = false
    end
end

local function OnEntityWake(inst, data)
    inst.entitysleeping = false
end

local function fn(Sim)
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
    --inst.Transform:SetScale(1.5,1.5,1.5)
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2.75, 1)
    inst.Transform:SetFourFaced()
    
    
    ----------
    
    MakeCharacterPhysics(inst, 10, .5)
    MakePoisonableCharacter(inst, "head")

    
    inst:AddTag("tallbird")
    inst:AddTag("animal")
    inst:AddTag("largecreature")
    inst.AnimState:SetBank("tallbird")
    inst.AnimState:SetBuild("ds_tallbird_basic")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Hide("beakfull")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 7

    inst:SetStateGraph("SGtallbird")
    
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
   
    ---------------------        
    
    
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TALLBIRD_HEALTH)

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "head"
    inst.components.combat:SetDefaultDamage(TUNING.TALLBIRD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.TALLBIRD_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(TUNING.TALLBIRD_ATTACK_RANGE)

    MakeLargeBurnableCharacter(inst, "head")
    MakeLargeFreezableCharacter(inst, "head")
    ------------------
    
    inst:AddComponent("knownlocations")

    inst:AddComponent("leader")

    ------------------
    
    inst:AddComponent("eater")
    inst.components.eater:SetOmnivore()
    
    ------------------
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(function() 
        local sleep = GetClock():IsNight() and not inst.components.combat.target
        return sleep
    end)
    
    inst.components.sleeper:SetWakeTest(function() 
        local sleep = GetClock():IsDay() or inst.components.combat.target
        return sleep
    end)
    ------------------
    
    inst:AddComponent("inspectable")
    
    ------------------
    
    inst:SetBrain(brain)

    inst.CanMakeNewHome = CanMakeNewHome
    inst.MakeNewHome = MakeNewHome

    inst:ListenForEvent("attacked", OnAttacked)

    inst:ListenForEvent("entitysleep", OnEntitySleep)
    inst:ListenForEvent("entitywake", OnEntityWake)

    return inst
end

return Prefab( "forest/monsters/tallbird", fn, assets, prefabs) 
