require "stategraphs/SGadultflytrap"

local assets=
{
    Asset("ANIM", "anim/venus_flytrap_lg_build.zip"),
	Asset("ANIM", "anim/venus_flytrap_planted.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
    Asset("MINIMAP_IMAGE", "mean_flytrap"),
}

local prefabs =
{
    "plantmeat",
    "venus_stalk",
    "vine",
    "nectar_pod",
}

SetSharedLootTable( 'adult_flytrap',
{
    {'plantmeat',   1.0},
    {'plantmeat',   0.5},   
    {'vine',        1.0},
    {'vine',        0.5},
    {'venus_stalk', 1.0},
    {'nectar_pod',  1.0},
    {'nectar_pod',  0.3},
})

local SHARE_TARGET_DIST = 15

local function grownplant(inst)
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local angle = math.random() * 360
    if angle > 360 then angle = angle - 360 end    
    local radius = 15
    local offset = FindWalkableOffset(pt, angle*DEGREES, radius, 20, true, false) -- try avoiding walls
    if offset then
        
    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, radius, {"flytrap"})
        if #ents<5 then            
            local plant = SpawnPrefab("mean_flytrap")
            local pt = pt+offset
            plant.Transform:SetPosition(pt.x,pt.y,pt.z)
            plant.sg:GoToState("enter")
            inst.sg:GoToState("taunt")
        end
    end

    inst.startGrowTask(inst)
end

local function OnNewTarget(inst, data)
    inst.keeptargetevenifnofood = nil
end

local function startGrowTask(inst, time)
    if not time then
        time = math.random()*(TUNING.TOTAL_DAY_TIME*2) + (TUNING.TOTAL_DAY_TIME*2)
    end

    if inst.growtask then inst.growtask:Cancel() inst.growtask = nil end

    inst.taskinfo = nil
    inst.growtask, inst.growtaskinfo = inst:ResumeTask(time, function() grownplant(inst) end)    

    --inst.growtask = inst:DoTaskInTime(time,function() grownplant(inst) end)
end

local function findfood(inst,guy)
    if guy.components.inventory then
        return guy.components.inventory:FindItem(
            function(item)   
                if item and item.components.edible then
                    if "MEAT" == item.components.edible.foodtype then                           
                        return true
                    end
                end
            end)
    end
end

local function retargetfn(inst)
    return FindEntity(inst, TUNING.ADULT_FLYTRAP_ATTACK_DIST, function(guy) 
        
        if guy:HasTag("plantkin") and (guy:GetDistanceSqToInst(inst) > TUNING.FLYTRAP_TARGET_DIST*TUNING.FLYTRAP_TARGET_DIST or not findfood(inst,guy)) then
            return false
        end        
        if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
            return (guy.components.combat.target == inst or guy:HasTag("character") or guy:HasTag("monster") or guy:HasTag("animal")) and not guy:HasTag("flytrap") and not (guy.prefab == inst.prefab)
        end
    end)
end

local function shouldKeepTarget(inst, target)
    if not inst.keeptargetevenifnofood and target:HasTag("plantkin") and not findfood(inst,target) then
        return false
    end
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        return distsq < TUNING.ADULT_FLYTRAP_STOPATTACK_DIST*TUNING.ADULT_FLYTRAP_STOPATTACK_DIST
    else
        return false
    end
end

local function OnAttacked(inst, data)  
    inst.components.combat:SetTarget(data.attacker)
    --inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("flytrap")and not dude.components.health:IsDead() end, 5)    
    inst.keeptargetevenifnofood = true
end

local function OnAttackOther(inst, data)
    --inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("flytrap") and not dude.components.health:IsDead() end, 5)
end

local function onsave(inst, data)
    if inst.growtaskinfo then
        data.growtask = inst:TimeRemainingInTask(inst.growtaskinfo)
    end
    if inst:HasTag("spawned")then
        data.spawned = true
    end
end

local function onload(inst, data)
    if data then 
        if data.growtask then
            startGrowTask(inst, data.growtask)
        end        
        if data.spawned then
            inst:AddTag("spawned")
        end
    end    
     
end

local function onSpawn(inst)
    if not inst:HasTag("spawned") then
        inst.start_scale = 1.4
        inst.inc_scale = (1.8 - 1.4) /5
        inst.sg:GoToState("grow")  
        inst:AddTag("spawned")
    else
        inst.sg:GoToState("idle")
        inst.Transform:SetScale(1.8,1.8,1.8)    
        inst.Transform:SetRotation(math.random(360))
    end
end

local function SanityAura(inst, observer)
    return not observer:HasTag("plantkin") and -TUNING.SANITYAURA_MED or 0
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
    local sound = inst.entity:AddSoundEmitter()    

    MakeObstaclePhysics(inst, .25)   
    inst.Transform:SetFourFaced()

    inst.AnimState:Hide("root")
    inst.AnimState:Hide("leaf")
    
    inst.AnimState:SetBank("venus_flytrap_planted")
    inst.AnimState:SetBuild("venus_flytrap_lg_build")
    inst.AnimState:PlayAnimation("idle")
 	inst.entity:AddSoundEmitter()

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("flytrap")
    inst:AddTag("hostile")
    inst:AddTag("animal")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "mean_flytrap.png" )

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ADULT_FLYTRAP_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.ADULT_FLYTRAP_ATTACK_DIST)
    inst.components.combat:SetDefaultDamage(TUNING.ADULT_FLYTRAP_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.ADULT_FLYTRAP_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    
    MakeLargeFreezableCharacter(inst)
    MakeMediumBurnableCharacter(inst, "stem")
    
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura
    
    inst.OnSave = onsave 
    inst.OnLoad = onload
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('adult_flytrap')

    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)
    
    inst:SetStateGraph("SGadultflytrap")
    
    inst.startGrowTask = startGrowTask

    startGrowTask(inst)

    inst.onSpawn = onSpawn
    inst:DoTaskInTime(0,function() onSpawn(inst) end)

    return inst
end

return Prefab( "marsh/monsters/adult_flytrap", fn, assets, prefabs) 
