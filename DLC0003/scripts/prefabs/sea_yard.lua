require "prefabutil"

local assets = 
{
	Asset("ANIM", "anim/sea_yard.zip"),
	Asset("MINIMAP_IMAGE", "sea_yard"),	
	Asset("ANIM", "anim/sea_yard_meter.zip"),	
}

local prefabs =
{
	"collapse_small",
	"sea_yard_arms_fx"
}

local function startTimer(inst, boat)
	inst.task_fix = inst:DoTaskInTime(1,function() 
		if boat.armsfx then
			inst.fixfn(inst, boat) 
		else
			inst.components.autofixer:TurnOff(boat)
		end
	end)
end

local function fixfn(inst, boat)
	if boat.components.boathealth and inst.components.autofixer:IsOn() then
		local oldpercent = boat.components.boathealth:GetPercent()
		local newpercent = math.min(1, oldpercent + TUNING.SEA_YARD_REPAIR_PER_SECOND_PERCENT)
		boat.components.boathealth:SetPercent(newpercent)
		if newpercent < 1 and inst.components.autofixer:IsOn() then
			startTimer(inst, boat)
		else
			inst.components.autofixer:TurnOff(boat)
		end	
	else
		inst.components.autofixer:TurnOff(boat)
	end
end

local function startFixingFn(inst, boat)
	if boat.components.boathealth and boat.components.boathealth:GetPercent() < 1 then
		if not boat.armsfx then
			local driver = boat.components.drivable.driver

			local arms = SpawnPrefab("sea_yard_arms_fx")
			arms.entity:SetParent(driver and driver.entity or boat.entity)
			arms.Transform:SetPosition(0, 0, 0)
			arms.AnimState:SetFinalOffset(5)
			
			boat.armsfx = arms
			inst.components.fueled:StartConsuming()
		end
	end	
	startTimer(inst, boat)
end

local function stopFixingFn(inst, boat)
	inst.components.fueled:StopConsuming()

	if inst.task_fix then
		inst.task_fix:Cancel()
	end

	if boat:IsValid() and boat.armsfx then
		boat.armsfx.stopfx(boat.armsfx, boat)
	end
end

local function ShouldStartFixing(boat)
	return boat.components.drivable and boat.components.boathealth and boat.components.boathealth:GetPercent() < .995 -- To not be deactivating and activating all the time.
end

local function ShouldKeepFixing(boat)
	return boat.components.drivable and boat.components.boathealth and boat.components.boathealth:GetPercent() < 1
end

local function OnKeepFixing(boat)
	if boat.armsfx then
		local parent = boat.armsfx.entity:GetParent()

		if not boat.components.drivable.driver and parent ~= boat then
			boat.armsfx.entity:SetParent(boat.entity)
			return
		end

		if boat.components.drivable.driver and parent == boat then
			boat.armsfx.entity:SetParent(boat.components.drivable.driver.entity)
		end
	end
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")

		inst.AnimState:PushAnimation("idle", true)
				
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull")
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

local function onturnon(inst)
	if not inst:HasTag("burnt") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull")
		inst:DoTaskInTime(18/30,function() inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull") end)
		inst.AnimState:PlayAnimation("enter")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onturnoff(inst)
	if not inst:HasTag("burnt") then
	    inst.AnimState:PushAnimation("idle", true)
		--inst.SoundEmitter:KillSound("idlesound")
	end
end

local function OnFuelSectionChange(old, new, inst)
	local fuelAnim = inst.components.fueled:GetCurrentSection()
	inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", fuelAnim)
end

local function OnFuelEmpty(inst)
	inst.components.autofixer:TurnOff()
end

local function ontakefuelfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
end

local function onplaced(inst)
	inst.components.autofixer.locked = false
	inst:RemoveEventCallback("animover", onplaced)

end

local function getstatus(inst, viewer)
	if inst.components.fueled and inst.components.fueled.currentfuel <= 0 then
		return "OFF"
	elseif inst.components.fueled and (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel) <= .25 then
		return "LOWFUEL"
	else
		return "ON"
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
	minimap:SetPriority( 5 )
	minimap:SetIcon( "sea_yard.png" )
    
	MakeObstaclePhysics(inst, .4)
    
	anim:SetBank("sea_yard")
	anim:SetBuild("sea_yard")
	anim:PlayAnimation("idle",true)

    inst:AddTag("structure")
    inst:AddTag("autofixer")
    inst:AddTag("nowaves")
    

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("autofixer")
	inst.components.autofixer:SetOnTurnOnOffFns(onturnon, onturnoff)
	inst.components.autofixer:SetStartStopFixingFns(startFixingFn, stopFixingFn)
	inst.components.autofixer:SetShouldFixTargetFn(ShouldStartFixing)
	inst.components.autofixer:SetKeepTargetFns(ShouldKeepFixing, OnKeepFixing)
	inst.components.autofixer:SetLocked()
	inst.components.autofixer:SetTags({"boat"})

	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(10)
	inst.components.fueled.ontakefuelfn = ontakefuelfn
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled:InitializeFuelLevel(TUNING.SEA_YARD_MAX_FUEL_TIME)
	inst.components.fueled.bonusmult = 0.5
	inst.components.fueled.fueltype = "TAR"

	inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", 10)

	inst:ListenForEvent( "onbuilt", function()
		anim:PlayAnimation("place")
		anim:PushAnimation("idle", true)
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/shipyard/craft")	

	    inst:ListenForEvent("animover",  onplaced )
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
    inst.fixfn = fixfn

	return inst
end

--Using old prefab names
return Prefab( "shipwrecked/sea_yard", fn, assets, prefabs),
	MakePlacer( "shipwrecked/sea_yard_placer", "sea_yard", "sea_yard", "placer" )
