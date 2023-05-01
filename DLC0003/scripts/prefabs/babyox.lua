require "brains/babyoxbrain"
require "stategraphs/SGox"
    
local assets=
{
    Asset("ANIM", "anim/ox_baby_build.zip"),
    Asset("ANIM", "anim/ox_basic.zip"),
    Asset("ANIM", "anim/ox_actions.zip"),
    Asset("ANIM", "anim/ox_basic_water.zip"),
    Asset("ANIM", "anim/ox_actions_water.zip"),
    Asset("SOUND", "sound/beefalo.fsb"),
}

local prefabs =
{
    "smallmeat",
    "meat",
    "poop",
    "ox",
}

local babyloot = {"smallmeat","smallmeat","smallmeat"}
local toddlerloot = {"smallmeat","smallmeat","smallmeat","smallmeat"}
local teenloot = {"meat","meat","meat"}

local sounds = {
    angry = "dontstarve_DLC002/creatures/OX_baby/angry",
    curious = "dontstarve_DLC002/creatures/OX_baby/curious",

    attack_whoosh = "dontstarve_DLC002/creatures/OX_baby/attack_whoosh",
    chew = "dontstarve_DLC002/creatures/OX_baby/chew",
    grunt = "dontstarve_DLC002/creatures/OX_baby/bellow",
    hairgrow_pop = "dontstarve_DLC002/creatures/OX_baby/hairgrow_pop",
    hairgrow_vocal = "dontstarve_DLC002/creatures/OX_baby/hairgrow_vocal",
    sleep = "dontstarve_DLC002/creatures/OX_baby/sleep",
    tail_swish = "dontstarve_DLC002/creatures/OX_baby/tail_swish",
    walk_land = "dontstarve_DLC002/creatures/OX_baby/walk_land",
    walk_water = "dontstarve_DLC002/creatures/OX_baby/walk_water",

    death = "dontstarve_DLC002/creatures/OX_baby/death",
    mating_call = "dontstarve_DLC002/creatures/OX_baby/mating_call",

    emerge = "dontstarve_DLC002/creatures/seacreature_movement/water_emerge_med",
    submerge = "dontstarve_DLC002/creatures/seacreature_movement/water_submerge_med",
}


local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("ox") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function FollowGrownOx(inst)
    local nearest = FindEntity(inst, 30, function(guy)
        return guy.components.leader and guy.components.leader:CountFollowers() < 1
    end, {"ox"}, {"baby"})
    if nearest and nearest.components.leader then
        nearest.components.leader:AddFollower(inst)
    end
end

local function Grow(inst)
    if inst.components.sleeper:IsAsleep() then
        inst.growUpPending = true
        inst.sg:GoToState("wake")
    else
        inst.sg:GoToState("grow_up")
    end
end

local function GetGrowTime()
    return GetRandomWithVariance(TUNING.BABYOX_GROW_TIME.base, TUNING.BABYOX_GROW_TIME.random)
end

local function SetBaby(inst)
    local scale = 0.5
    inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(babyloot)
    inst.components.sleeper:SetResistance(1)
end

local function SetToddler(inst)
    local scale = 0.7
    inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(toddlerloot)
    inst.components.sleeper:SetResistance(2)
end

local function SetTeen(inst)
    local scale = 0.9
    inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(teenloot)
    inst.components.sleeper:SetResistance(2)
end

local function SetFullyGrown(inst)
    local grown = SpawnPrefab("ox")
    grown.Transform:SetPosition(inst.Transform:GetWorldPosition())
    grown.Transform:SetRotation(inst.Transform:GetRotation())
    grown.sg:GoToState("grow_up_adult_pop")
    inst:Remove()
end

local function OnWaterChange(inst, onwater)
    local noanim = inst:GetTimeAlive() < 1
    inst.sg:GoToState(onwater and "submerge" or "emerge", noanim)
end

local function OnPooped(inst, poop)
    local heading_angle = -(inst.Transform:GetRotation()) + 180

    local pos = Vector3(inst.Transform:GetWorldPosition())
    pos.x = pos.x + (math.cos(heading_angle*DEGREES))
    pos.y = pos.y + 0.9
    pos.z = pos.z + (math.sin(heading_angle*DEGREES))
    poop.Transform:SetPosition(pos.x, pos.y, pos.z)

    if poop.components.inventoryitem then
        poop.components.inventoryitem:OnStartFalling()
    end
end

local function OnEntityWake(inst)
    inst.components.tiletracker:Start()
end

local function OnEntitySleep(inst)
    inst.components.tiletracker:Stop()
end

local growth_stages =
{
    {name="baby", time = GetGrowTime, fn = SetBaby},
    {name="toddler", time = GetGrowTime, fn = SetToddler, growfn = Grow},
    {name="teen", time = GetGrowTime, fn = SetTeen, growfn = Grow},
    {name="grown", time = GetGrowTime, fn = SetFullyGrown, growfn = Grow},
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.sounds = sounds
    inst.walksound = sounds.walk_land
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 2.5, 1.25 )
    
    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(0.5, 0.5, 0.5)

    MakeAmphibiousCharacterPhysics(inst, 50, .5)
    MakePoisonableCharacter(inst, "beefalo_body")
    
    inst:AddTag("ox")
    inst:AddTag("baby")
    anim:SetBank("ox")
    anim:SetBuild("ox_baby_build")
    anim:PlayAnimation("idle_loop", true)
    
    inst:AddTag("animal")

    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
     
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BABYOX_HEALTH)

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("sleeper")
    
    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "oxherd"
    
    inst:AddComponent("follower")
    inst.components.follower.canaccepttarget = true

    
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(80, 110)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetOnSpawnFn(OnPooped)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()
    
    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable.growonly = true
    inst.components.growable:SetStage(1)
    inst.components.growable:StartGrowing()

    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeLargeFreezableCharacter(inst, "beefalo_body")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 9
    
    inst:DoTaskInTime(1, FollowGrownOx)
    
    inst:AddComponent("tiletracker")
    inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)

    local brain = require "brains/babyoxbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGox")

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab( "forest/animals/babyox", fn, assets, prefabs) 
