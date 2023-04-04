local function MakePreparedFood(data)

	local assets=
	{
		Asset("ANIM", "anim/cook_pot_food.zip"),
	}
	
	local prefabs = 
	{
		"spoiled_food",
	}
	
	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBuild("cook_pot_food")
		inst.AnimState:SetBank("food")
		inst.AnimState:PlayAnimation(data.name, false)
	    
	    inst:AddTag("preparedfood")

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health
		inst.components.edible.hungervalue = data.hunger
		inst.components.edible.foodtype = data.foodtype or "GENERIC"
		inst.components.edible.foodstate = data.foodstate or "PREPARED"
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible.naughtyvalue = data.naughtiness or 0
		inst.components.edible.caffeinedelta = data.caffeinedelta or 0
		inst.components.edible.caffeineduration = data.caffeineduration or 0

		if data.boost_surf then
			inst.components.edible.surferdelta = TUNING.HYDRO_FOOD_BONUS_SURF
			inst.components.edible.surferduration = TUNING.FOOD_SPEED_AVERAGE		
		end
		if data.boost_dry then
			inst.components.edible.autodrydelta = TUNING.HYDRO_FOOD_BONUS_DRY
			inst.components.edible.autodryduration = TUNING.FOOD_SPEED_AVERAGE
		end
		if data.boost_cool then
			inst.components.edible.autocooldelta = TUNING.HYDRO_FOOD_BONUS_COOL_RATE
		end

		inst:AddComponent("inspectable")
		inst.wet_prefix = data.wet_prefix

		inst:AddComponent("inventoryitem")
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM


		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_SLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		if data.tags then
			for i,v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
		
	    
        MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeInventoryFloatable(inst, data.name.."_water", data.name)
		---------------------        

		inst:AddComponent("bait")
	    
		------------------------------------------------
		inst:AddComponent("tradable")
	    
		------------------------------------------------  
	    
		return inst
	end

	return Prefab( "common/inventory/"..data.name, fn, assets, prefabs)
end


local prefs = {}

local foods = require("preparedfoods")
for k,v in pairs(foods) do
	table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs) 

