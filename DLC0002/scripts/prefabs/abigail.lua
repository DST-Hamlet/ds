require "stategraphs/SGghost"

local assets =
{
	Asset("ANIM", "anim/ghost.zip"),
	Asset("ANIM", "anim/ghost_wendy_build.zip"),
	Asset("SOUND", "sound/ghost.fsb"),
}

local prefabs = 
{
}
 
require "brains/abigailbrain"

local function Retarget(inst)
    local notags = {"FX", "NOCLICK","INLIMBO"}
    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end, nil, notags)

    return newtarget
end

local function OnAttacked(inst, data)
    local attacker = data.target or data.attacker

    if attacker and attacker:HasTag("player") then
        inst.components.health:SetVal(0)
    end
end

local function auratest(inst, target)

    if target == GetPlayer() then return false end

    local leader = inst.components.follower.leader
    if target.components.combat.target and ( target.components.combat.target == inst or target.components.combat.target == leader) then return true end
    if inst.components.combat.target == target then return true end

    if leader then
        if leader == target then return false end
        if target.components.follower and target.components.follower.leader == leader then return false end
    end

    return (target:HasTag("monster") or target:HasTag("prey")) and inst.components.combat:CanTarget(target)
end

local function updatedamage(inst)
    if GetClock():IsDay() then
        inst.components.combat.defaultdamage = .5*TUNING.ABIGAIL_DAMAGE_PER_SECOND 
    elseif GetClock():IsNight() then
        inst.components.combat.defaultdamage = 2*TUNING.ABIGAIL_DAMAGE_PER_SECOND     
    elseif GetClock():IsDusk() then
        inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND 
    end

end
   


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    local light = inst.entity:AddLight()
   
    MakeAmphibiousGhostPhysics(inst, 1, .5)

    light:SetIntensity(.6)
    light:SetRadius(.5)
    light:SetFalloff(.6)
    light:Enable(true)
    light:SetColour(180/255, 195/255, 225/255)
    
    local brain = require "brains/abigailbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("ghost")
    anim:SetBuild("ghost_wendy_build")
    anim:SetBloomEffectHandle( "shaders/anim.ksh" )
    anim:PlayAnimation("idle", true)
    --inst.AnimState:SetMultColour(1,1,1,.6)
    
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("girl")
    inst:AddTag("ghost")
    inst:AddTag("noauradamage")
    inst:AddTag("notraptrigger")
    inst:AddTag("abigail")
    inst:AddTag("amphibious")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED*.5
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED
    
    inst:SetStateGraph("SGghost")

    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ABIGAIL_HEALTH)
    inst.components.health:StartRegen(1, 1)

	inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND
    inst.components.combat.playerdamagepercent = TUNING.ABIGAIL_DMG_PLAYER_PERCENT
    inst.components.combat:SetRetargetFunction(3, Retarget)

    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 1
    inst.components.aura.ignoreallies = true
    inst.components.aura.auratestfn = auratest
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"abigail_flower"})
    ------------------    
    
    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl_LP", "howl")
    
    inst:AddComponent("follower")
	local player = GetPlayer()
	if player and player.components.leader then
		player.components.leader:AddFollower(inst)        
	end
    inst.components.follower:SetFollowExitDestinations({EXIT_DESTINATION.LAND,EXIT_DESTINATION.WATER})

    inst:ListenForEvent("newcombattarget", OnAttacked)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:ListenForEvent( "dusktime", function() updatedamage(inst) end , GetWorld())
    inst:ListenForEvent( "daytime", function() updatedamage(inst) end , GetWorld())
    inst:ListenForEvent( "nighttime", function() updatedamage(inst) end , GetWorld())
    updatedamage(inst)

    inst:AddComponent("characterspecific")
    inst.components.characterspecific:SetOwner("wendy")
    
    return inst
end

return Prefab( "common/monsters/abigail", fn, assets, prefabs ) 
