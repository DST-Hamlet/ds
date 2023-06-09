local assets =
{
	Asset("ANIM", "anim/tallbird_egg.zip"),
}

local prefabs =
{
    "smallbird",
    "tallbird",
    "tallbirdegg",
}    

local TALLBIRD_LAY_DIST = 16

local function StopNesting(inst)
    if inst.nesttask then
        inst.nesttask:Cancel()
        inst.nesttask = nil
    end
    inst.nesttime = nil
end

local function ForceLay(inst)
	if inst.components.childspawner and inst.components.pickable then
	    for k,v in pairs(inst.components.childspawner.childrenoutside) do
		    if distsq(Vector3(v.Transform:GetWorldPosition()), Vector3(inst.Transform:GetWorldPosition()) ) < TALLBIRD_LAY_DIST*TALLBIRD_LAY_DIST then
		        inst.components.pickable:Regen()
		        break
		    end
	    end
	end
end

local function DoNesting(inst)
    StopNesting(inst)
    if inst.components.pickable and not inst.components.pickable:CanBePicked() then
        inst.readytolay = true
        if inst:IsAsleep() then
            ForceLay(inst)
        end
    end
end

local function StartNesting(inst, time)
    StopNesting(inst)
    time = time or (TUNING.TALLBIRD_LAY_EGG_TIME_MIN + math.random() * TUNING.TALLBIRD_LAY_EGG_TIME_VAR )
    inst.nesttime = GetTime() + time
    inst.nesttask = inst:DoTaskInTime(time, DoNesting)
end

local function onpicked(inst, picker)
	inst.thief = picker
	inst.AnimState:PlayAnimation("nest")
	inst.components.childspawner.noregen = true
	if inst.components.childspawner and picker then
		for k,v in pairs(inst.components.childspawner.childrenoutside) do
			if v.components.combat then
				v.components.combat:SuggestTarget(picker)
			end
		end
	end
	inst:DoTaskInTime(0, StartNesting)
end

local function onmakeempty(inst)
	inst.AnimState:PlayAnimation("nest")
	inst.components.childspawner.noregen = true
end

local function onregrow(inst)
	inst.AnimState:PlayAnimation("eggnest")
	inst.components.childspawner.noregen = false
	StopNesting(inst)
	inst.thief = nil
	inst.readytolay = nil
end

local function onvacate(inst)
	if inst.components.pickable then
		inst.components.pickable:MakeEmpty()
        StartNesting(inst)
	end
end

local function onsleep(inst)
    if inst.components.pickable and not inst.components.pickable:CanBePicked() and inst.readytolay then
        ForceLay(inst)
    end
end

local function OnSave(inst, data)
    data.readytolay = inst.readytolayson
    data.canspawn = inst.canspawnsmallbird
    data.havespawned = inst.spawnedsmallbirdthisseason
    if inst.nesttime and inst.nesttime > GetTime() then
        data.timetonest = inst.nesttime - GetTime()
    end
end

local function OnLoad(inst, data)
    if data then
        inst.readytolay = data.readytolay
        if data.timetonest then
            StartNesting(inst, data.timetonest)
        end
        inst.canspawnsmallbird = data.canspawn or true
        inst.spawnedsmallbirdthisseason = data.canspawn or false
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "tallbirdnest.png" )
   
    anim:SetBuild("tallbird_egg")
    anim:SetBank("egg")
    anim:PlayAnimation("eggnest", false)
    inst.AnimState:SetFinalOffset(-1)
    
    inst:AddComponent("pickable")
    --inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable:SetUp("tallbirdegg", nil)
    inst.components.pickable:SetOnPickedFn(onpicked)
    inst.components.pickable:SetOnRegenFn(onregrow)
    inst.components.pickable:SetMakeEmptyFn(onmakeempty)    
    
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    
    -------------------
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "tallbird"
	inst.components.childspawner.spawnoffscreen = true
	inst.components.childspawner:SetRegenPeriod(5*16*TUNING.SEG_TIME)
	inst.components.childspawner:SetSpawnPeriod(0)
	inst.components.childspawner:SetSpawnedFn(onvacate)
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:StartSpawning()
    -------------------
   
    inst:AddComponent("inspectable")
	inst:ListenForEvent("entitysleep", onsleep)
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

    inst.StartNesting = StartNesting

    inst:ListenForEvent("seasonChange", function(it, data)
        if data.season == SEASONS.SPRING then
            if (inst.spawnedsmallbirdthisseason == nil or inst.spawnedsmallbirdthisseason == false)
            and (inst.canspawnsmallbird == nil or inst.canspawnsmallbird == true) then
                inst:DoTaskInTime(math.random(TUNING.MIN_SPRING_SMALL_BIRD_SPAWN_TIME, TUNING.MAX_SPRING_SMALL_BIRD_SPAWN_TIME), function(inst)
                    local tallbird = nil
                    for k,v in pairs(inst.components.childspawner.childrenoutside) do
                        if v.prefab == "tallbird" then tallbird = v break end
                    end
                    if tallbird and tallbird:IsValid() then
                        inst.canspawnsmallbird = false
                        inst.spawnedsmallbirdthisseason = true
                        if tallbird.entitysleeping then
                            local smallbird = SpawnPrefab("smallbird")
                            smallbird:PushEvent("SetUpSpringSmallBird", {smallbird=smallbird, tallbird=tallbird})
                        else
                            tallbird.pending_spawn_smallbird = true
                        end
                    end
                end)
            end
        else
            inst.spawnedsmallbirdthisseason = false
        end
    end, GetWorld())
   
    return inst
end

return Prefab( "common/objects/tallbirdnest", fn, assets, prefabs) 
