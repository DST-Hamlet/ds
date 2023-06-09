require "prefabutil"

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation(inst.components.prototyper.on and "proximity_loop" or "idle", true)
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end
--[[
local function onFloodedStart(inst)
	if inst.components.prototyper then 
		inst.components.prototyper.disabled = true 
	end 
end 


local function onFloodedEnd(inst)
	if inst.components.prototyper then 
		inst.components.prototyper.disabled = false 
	end 
end 
]]
local function createmachine(level, name, soundprefix, techtree)
	
	local function onturnon(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("proximity_loop", true)
			
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_idle_LP","idlesound")
		end
	end

	local function onturnoff(inst)
		if not inst:HasTag("burnt") then
		    inst.AnimState:PushAnimation("idle", true)
			inst.SoundEmitter:KillSound("idlesound")
		end
	end

	local assets = 
	{
		Asset("ANIM", "anim/"..name..".zip"),
	}

	local prefabs =
	{
		"collapse_small",
	}


	local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		local minimap = inst.entity:AddMiniMapEntity()
		inst.entity:AddSoundEmitter()
		minimap:SetPriority( 5 )
		minimap:SetIcon( name..".png" )
	    
		MakeObstaclePhysics(inst, .4)
	    
		anim:SetBank(name)
		anim:SetBuild(name)
		anim:PlayAnimation("idle")

		inst:AddTag("prototyper")
        inst:AddTag("structure")
        inst:AddTag("level"..level)
		
		inst:AddComponent("inspectable")
		inst:AddComponent("prototyper")
		inst.components.prototyper.onturnon = onturnon
		inst.components.prototyper.onturnoff = onturnoff

--[[
		inst:AddComponent("floodable")
		inst.components.floodable.onStartFlooded = onFloodedStart
		inst.components.floodable.onStopFlooded = onFloodedEnd
		inst.components.floodable.floodEffect = "shock_machines_fx"
		inst.components.floodable.floodSound = "dontstarve_DLC002/creatures/jellyfish/electric_land"
]]
		
		inst.components.prototyper.trees = techtree
		inst.components.prototyper.onactivate = function()
			if not inst:HasTag("burnt") then
				inst.AnimState:PlayAnimation("use")
				inst.AnimState:PushAnimation("idle")
				inst.AnimState:PushAnimation("proximity_loop", true)
				inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_run","sound")

				inst:DoTaskInTime(1.5, function() 
					inst.SoundEmitter:KillSound("sound")
					inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_ding","sound")		
				end)
			end
		end
		
		inst:ListenForEvent( "onbuilt", function()
			inst.components.prototyper.on = true
			anim:PlayAnimation("place")
			anim:PushAnimation("idle")
			anim:PushAnimation("proximity_loop", true)
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_place")
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_idle_LP","idlesound")				
		end)		

		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)		
		MakeSnowCovered(inst, .01)

		inst.OnSave = onsave 
        inst.OnLoad = onload

		return inst
	end
	return Prefab( "common/objects/"..name, fn, assets, prefabs)
end
--Using old prefab names
return createmachine(2, "researchlab5", "lvl2", TUNING.PROTOTYPER_TREES.SEALAB),
	MakePlacer( "common/researchlab5_placer", "researchlab5", "researchlab5", "idle" )
