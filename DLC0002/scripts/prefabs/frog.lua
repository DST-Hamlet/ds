require "brains/frogbrain"
require "stategraphs/SGfrog"

local assets=
{
	Asset("ANIM", "anim/frog.zip"),
	Asset("ANIM", "anim/frog_build.zip"),
	Asset("ANIM", "anim/frog_yellow_build.zip"),
	Asset("SOUND", "sound/frog.fsb"),
}

local poisonassets=
{
	Asset("ANIM", "anim/frog.zip"),
	Asset("ANIM", "anim/frog_yellow_build.zip"),
	Asset("SOUND", "sound/frog.fsb"),
}

local prefabs =
{
	"froglegs",
	"splash",
	"venomgland",
}
 

local function retargetfn(inst)
	if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
		local notags = {"FX", "NOCLICK","INLIMBO"}
		return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
			if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
				return guy.components.inventory ~= nil
			end
		end, nil, notags)
	end
end

local function ShouldSleep(inst)
    if inst.components.knownlocations:GetLocation("home") ~= nil then
        return false
    end

    -- Homeless frogs will sleep at night.
    return GetClock():IsNight()
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
	local fx = SpawnPrefab("splash")
	local pos = inst:GetPosition()
	fx.Transform:SetPosition(pos.x, pos.y, pos.z)

	--local splash = PlayFX(Vector3(inst.Transform:GetWorldPosition() ), "splash", "splash", "splash")
	inst.SoundEmitter:PlaySound("dontstarve/frog/splash")
end

local function commonfn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	
	shadow:SetSize( 1.5, .75 )
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("frog")
	inst.AnimState:SetBuild("frog_build")
	inst.AnimState:PlayAnimation("idle")

	MakeCharacterPhysics(inst, 1, .3)
	 
	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 8

	inst:SetStateGraph("SGfrog")

	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("smallcreature")
	inst:AddTag("frog")
	inst:AddTag("canbetrapped")    

	local brain = require "brains/frogbrain"
	inst:SetBrain(brain)
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.FROG_HEALTH)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"froglegs"})
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.FROG_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, retargetfn)

	inst.components.combat.onhitotherfn = function(inst, other, damage) inst.components.thief:StealItem(other) end
	
	inst:AddComponent("thief")
	
	MakeTinyFreezableCharacter(inst, "frogsack")

	
	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("goinghome", OnGoingHome)
	
	return inst
end

local function poisonfn(Sim)
	local inst = commonfn(Sim)

	--inst.entity:AddAnimState()
	--inst.AnimState:SetBank("frog")
	inst.AnimState:SetBuild("frog_yellow_build")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("poisonous")
	inst.components.combat.poisonous = true
	inst.components.lootdropper:AddRandomLoot("venomgland", 0.5)

	return inst
end

return Prefab( "forest/animals/frog", commonfn, assets, prefabs),
	   Prefab( "forest/animals/frog_poison", poisonfn, poisonassets, prefabs)
