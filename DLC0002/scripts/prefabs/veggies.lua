require "tuning"


local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity)
	return {
		health = health,
		hunger = hunger,
		cooked_health = cooked_health,
		cooked_hunger = cooked_hunger,
		seed_weight = seedweight,
		perishtime = perish_time,
		cooked_perishtime = cooked_perish_time,
		sanity = sanity,
		cooked_sanity = cooked_sanity

	}
end

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

VEGGIES =
{

	cave_banana = MakeVegStats(0,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0),

	carrot = MakeVegStats(COMMON,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0),

	corn = MakeVegStats(COMMON, TUNING.CALORIES_MED,	TUNING.HEALING_SMALL,	TUNING.PERISH_MED, 0,
								TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_SLOW, 0),

	pumpkin = MakeVegStats(UNCOMMON,	TUNING.CALORIES_LARGE,	TUNING.HEALING_SMALL,	TUNING.PERISH_MED, 0,
										TUNING.CALORIES_LARGE,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0),

	eggplant = MakeVegStats(UNCOMMON,	TUNING.CALORIES_MED,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_MED, 0,
										TUNING.CALORIES_MED,	TUNING.HEALING_MED,		TUNING.PERISH_FAST, 0),

	durian = MakeVegStats(RARE, TUNING.CALORIES_MED,	-TUNING.HEALING_SMALL,	TUNING.PERISH_MED, -TUNING.SANITY_TINY,
								TUNING.CALORIES_MED,	0,						TUNING.PERISH_FAST, -TUNING.SANITY_TINY),

	pomegranate = MakeVegStats(RARE,	TUNING.CALORIES_TINY,	TUNING.HEALING_SMALL,		TUNING.PERISH_FAST, 0,
										TUNING.CALORIES_SMALL,	TUNING.HEALING_MED,	TUNING.PERISH_SUPERFAST, 0),

	dragonfruit = MakeVegStats(RARE,	TUNING.CALORIES_TINY,	TUNING.HEALING_SMALL,		TUNING.PERISH_FAST, 0,
										TUNING.CALORIES_SMALL,	TUNING.HEALING_MED,	TUNING.PERISH_SUPERFAST, 0),

	berries = MakeVegStats(0,	TUNING.CALORIES_TINY,	0,	TUNING.PERISH_FAST, 0,
								TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_SUPERFAST, 0),

	cactus_meat = MakeVegStats(0, TUNING.CALORIES_SMALL, -TUNING.HEALING_SMALL, TUNING.PERISH_MED, -TUNING.SANITY_TINY,
								  TUNING.CALORIES_SMALL, TUNING.HEALING_TINY, TUNING.PERISH_MED, TUNING.SANITY_MED),

	watermelon = MakeVegStats(UNCOMMON, TUNING.CALORIES_SMALL, TUNING.HEALING_SMALL, TUNING.PERISH_FAST, TUNING.SANITY_TINY,
							  TUNING.CALORIES_SMALL, TUNING.HEALING_TINY, TUNING.PERISH_SUPERFAST, TUNING.SANITY_TINY*1.5),

	coffeebeans = MakeVegStats(0,	TUNING.CALORIES_TINY,	0,	TUNING.PERISH_FAST, 0,
								TUNING.CALORIES_TINY,	0,	TUNING.PERISH_SLOW, -TUNING.SANITY_TINY),

	sweet_potato = MakeVegStats(COMMON,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0),
}


local function MakeVeggie(name, has_seeds, iswater)

	local assetname = name

	local assets=
	{
		Asset("ANIM", "anim/"..assetname..".zip"),
	}
	local assets_cooked=
	{
		Asset("ANIM", "anim/"..assetname..".zip"),
	}

	local assets_seeds =
	{
		Asset("ANIM", "anim/seeds.zip"),
	}

	local prefabs =
	{
		name.."_cooked",
		"spoiled_food",
	}

	if has_seeds then
		table.insert(prefabs, name.."_seeds")
	end

	local function fn_seeds()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()

		MakeInventoryPhysics(inst)
		MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)
		inst.AnimState:SetBank("seeds")
		inst.AnimState:SetBuild("seeds")
		inst.AnimState:SetRayTestOnBB(true)

		inst:AddComponent("edible")
		inst.components.edible.foodtype = "SEEDS"
		inst.components.edible.foodstate = "RAW"

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM


		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")

		inst.AnimState:PlayAnimation("idle")
		inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
		inst.components.edible.hungervalue = TUNING.CALORIES_TINY

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"


		inst:AddComponent("cookable")
		inst.components.cookable.product = "seeds_cooked"

		inst:AddComponent("bait")
		inst:AddComponent("plantable")
		inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
		inst.components.plantable.product = name

		return inst
	end

	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(assetname)
		inst.AnimState:SetBuild(assetname)
		inst.AnimState:PlayAnimation("idle")

		inst:AddComponent("edible")
		inst:AddComponent("perishable")

		inst.components.edible.healthvalue = VEGGIES[name].health
		inst.components.edible.hungervalue = VEGGIES[name].hunger
		inst.components.edible.sanityvalue = VEGGIES[name].sanity or 0
		inst.components.perishable:SetPerishTime(VEGGIES[name].perishtime)
	
		inst.components.edible.foodtype = "VEGGIE"
		inst.components.edible.foodstate = "RAW"

		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("stackable")


		local is_big = name == "pumpkin" or name == "eggplant" or name == "durian" or name == "watermelon"
		if not is_big then
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		end

		local is_cooler = name == "watermelon"
		if is_cooler then
			inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    		inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF
		end

		local is_blown_in_hurricane = name == "carrot" or name == "berries"
		if is_blown_in_hurricane then
			MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		MakeInventoryFloatable(inst, "idle_water", "idle")
		---------------------

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")

		------------------------------------------------

		inst:AddComponent("cookable")
		inst.components.cookable.product = name.."_cooked"

		local is_banana = name == "cave_banana"
		if is_banana then
			--inst.components.inventoryitem:ChangeImageName("bananas")
			inst:AddComponent("named")
			inst.components.named:SetName(STRINGS.NAMES["BANANA"])
		end

		return inst
	end

	local function fn_cooked(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(assetname)
		inst.AnimState:SetBuild(assetname)
		inst.AnimState:PlayAnimation("cooked")


		inst:AddComponent("perishable")
		inst:AddComponent("edible")

		inst.components.perishable:SetPerishTime(VEGGIES[name].cooked_perishtime)
		inst.components.edible.healthvalue = VEGGIES[name].cooked_health
		inst.components.edible.hungervalue = VEGGIES[name].cooked_hunger
		inst.components.edible.sanityvalue = VEGGIES[name].cooked_sanity or 0

		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst.components.edible.foodtype = "VEGGIE"
		inst.components.edible.foodstate = "COOKED"

		local is_caffeinated = name == "coffeebeans"
		if is_caffeinated then
			inst.components.edible.caffeinedelta = TUNING.CAFFEINE_FOOD_BONUS_SPEED
			inst.components.edible.caffeineduration = TUNING.FOOD_SPEED_AVERAGE
		end

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inspectable")

		local is_banana = name == "cave_banana"
		if is_banana then
			inst:AddComponent("named")
			--inst.components.inventoryitem:ChangeImageName("bananas_cooked")
			inst.components.named:SetName(STRINGS.NAMES["BANANA_COOKED"])
		end

		local is_blown_in_hurricane = name == "carrot" or name == "berries"
		if is_blown_in_hurricane then
			MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)
		end

		inst:AddComponent("inventoryitem")

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		MakeInventoryFloatable(inst, "cooked_water", "cooked")
		---------------------

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")

		return inst
	end

	local base
	local cooked
	base = Prefab( "common/inventory/"..name, fn, assets, prefabs)
	cooked = Prefab( "common/inventory/"..name.."_cooked", fn_cooked, assets_cooked)
	local seeds = has_seeds and Prefab( "common/inventory/"..name.."_seeds", fn_seeds, assets_seeds) or nil
	return base, cooked, seeds
end


local prefs = {}
for veggiename,veggiedata in pairs(VEGGIES) do
	local veg, cooked, seeds = MakeVeggie(veggiename, veggiename ~= "coffeebeans" and veggiename ~= "berries" and veggiename ~= "cave_banana" and veggiename ~= "cactus_meat", false)
	table.insert(prefs, veg)
	table.insert(prefs, cooked)
	if seeds then
		table.insert(prefs, seeds)
	end
end


return unpack(prefs)
