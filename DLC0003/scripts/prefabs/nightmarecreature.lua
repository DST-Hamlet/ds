require "brains/nightmarecreaturebrain"
require "stategraphs/SGshadowcreature"

local prefabs =
{
    "nightmarefuel",
}

local function retargetfn(inst)
    local entity = FindEntity(inst, TUNING.SHADOWCREATURE_TARGET_DIST, function(guy) 
		return guy:HasTag("player") and inst.components.combat:CanTarget(guy)
    end)
    return entity
end

SetSharedLootTable( 'nightmare_creature',
{
    {'nightmarefuel', 1.0},
    {'nightmarefuel', 0.5},
})

local function CalcSanityAura(inst, observer)	
	return -TUNING.SANITYAURA_LARGE
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("shadowcreature") and not dude.components.health:IsDead() end, 1)
end

local function onsave(inst, data)
    if inst:HasTag("aporkalypse_cleanup")then
        data.aporkalypse_cleanup = true
    end
end

local function onload(inst, data)
    if data then 
        if data.aporkalypse_cleanup then
            inst:AddTag("aporkalypse_cleanup")
			inst:ListenForEvent("endaporkalypse",
		        function(eventsender)
		            if inst:HasTag("aporkalypse_cleanup") then
	    	            inst:Remove()
	        	    end
		        end, 
				GetWorld())
        end        
    end    
end


local function MakeShadowCreature(data)

    local bank = data.bank 
    local build = data.build 
    
    local assets=
    {
	    Asset("ANIM", "anim/"..data.build..".zip"),
    }
    
    local sounds = 
    {
        attack = "dontstarve/sanity/creature"..data.num.."/attack",
        attack_grunt = "dontstarve/sanity/creature"..data.num.."/attack_grunt",
        death = "dontstarve/sanity/creature"..data.num.."/die",
        idle = "dontstarve/sanity/creature"..data.num.."/idle",
        taunt = "dontstarve/sanity/creature"..data.num.."/taunt",
        appear = "dontstarve/sanity/creature"..data.num.."/appear",
        disappear = "dontstarve/sanity/creature"..data.num.."/dissappear",
    }

    local function fn()
	    local inst = CreateEntity()
	    local trans = inst.entity:AddTransform()
	    local anim = inst.entity:AddAnimState()
        local physics = inst.entity:AddPhysics()
	    local sound = inst.entity:AddSoundEmitter()
        inst.Transform:SetFourFaced()
        inst:AddTag("shadowcreature")
    	
        MakeCharacterPhysics(inst, 10, 1.5)
        inst.Physics:ClearCollisionMask()
        inst.Physics:SetCollisionGroup(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.GROUND)

        anim:SetBank(bank)
        anim:SetBuild(build)
        anim:PlayAnimation("idle_loop")
        anim:SetMultColour(1, 1, 1, 0.5)

        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor.walkspeed = data.speed
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.pathcaps = { ignorecreep = true }

        inst.sounds = sounds
        inst:SetStateGraph("SGshadowcreature")

        inst:AddTag("monster")
	    inst:AddTag("hostile")
        inst:AddTag("shadow")
        inst:AddTag("windspeedimmune")
        inst:AddTag("notraptrigger")

        local brain = require "brains/nightmarecreaturebrain"
        inst:SetBrain(brain)
        
	    inst:AddComponent("sanityaura")
	    inst.components.sanityaura.aurafn = CalcSanityAura

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.health)
		
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(data.damage)
        inst.components.combat:SetAttackPeriod(data.attackperiod)
        inst.components.combat:SetRetargetFunction(3, retargetfn)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable('nightmare_creature')
        
        inst:ListenForEvent("attacked", OnAttacked)
        -- if GetNightmareClock() then
        --     inst:ListenForEvent( "phasechange", 
        --                         function (source,data)
        --                             dprint("phase:",data.newphase)
        --                             if data.newphase == "dawn" then
        --                                 local dawntime = GetNightmareClock():GetDawnTime()
        --                                 inst:DoTaskInTime(GetRandomWithVariance(dawntime/2,dawntime/3),
        --                                                     function()
        --                                                         -- otherwise we end up with a lot of piles of nightmareful
        --                                                         inst.components.lootdropper:SetLoot({})
        --                                                         inst.sg:GoToState("disappear")
        --                                                     end)
        --                             end
        --                         end,
        --                         GetWorld())

        -- end

        inst:AddComponent("knownlocations")    

	    inst.OnSave = onsave
	    inst.OnLoad = onload

        return inst
    end
        
    return Prefab("monsters/"..data.name, fn, assets, prefabs)
end


local data = {{name="crawlingnightmare", build = "shadow_insanity1_basic", bank = "shadowcreature1", num = 1, speed = TUNING.CRAWLINGHORROR_SPEED, health=TUNING.CRAWLINGHORROR_HEALTH, damage=TUNING.CRAWLINGHORROR_DAMAGE, attackperiod = TUNING.CRAWLINGHORROR_ATTACK_PERIOD, sanityreward = TUNING.SANITY_MED},
			  {name="nightmarebeak", build = "shadow_insanity2_basic", bank = "shadowcreature2", num = 2, speed = TUNING.TERRORBEAK_SPEED, health=TUNING.TERRORBEAK_HEALTH, damage=TUNING.TERRORBEAK_DAMAGE, attackperiod = TUNING.TERRORBEAK_ATTACK_PERIOD, sanityreward = TUNING.SANITY_LARGE}}

local ret = {}
for k,v in pairs(data) do
	table.insert(ret, MakeShadowCreature(v))
end


return unpack(ret) 
