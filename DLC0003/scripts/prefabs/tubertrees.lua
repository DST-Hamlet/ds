local assets =
{
	Asset("ANIM", "anim/tuber_tree_build.zip"),
	Asset("ANIM", "anim/tuber_bloom_build.zip"),

	Asset("ANIM", "anim/tuber_tree.zip"),
	Asset("ANIM", "anim/dust_fx.zip"),
	Asset("SOUND", "sound/forest.fsb"),
	--Asset("INV_IMAGE", "jungleTreeSeed"),
	Asset("MINIMAP_IMAGE", "tuber_trees"),
	Asset("MINIMAP_IMAGE", "tuber_trees_stump"),
	Asset("MINIMAP_IMAGE", "tuber_trees_burnt"),
}

local prefabs =
{
	"charcoal",
	"chop_mangrove_pink",
	"fall_mangrove_pink",
	"tuber_crop",
	"tuber_bloom_crop",
	"tuber_crop_cooked",
	"tuber_bloom_crop_cooked",
}

local builds =
{
	normal = {
		file="tuber_tree_build",
		prefab_name="tubertree",
		tuberslots_short ={5,6},
		tuberslots_tall ={8,5,7},
	},
	blooming = {
		file="tuber_bloom_build",
		prefab_name="tubertree",		
		tuberslots_short ={5,6},
		tuberslots_tall ={8,5,7},		
	}	
}

local function makeanims(stage)
	return {
		idle="idle_"..stage,
		sway1="sway1_loop_"..stage,
		sway2="sway2_loop_"..stage,
		chop="chop_"..stage,
		fallleft="fallleft_"..stage,
		fallright="fallright_"..stage,
		stump="stump_"..stage,
		burning="burning_loop_"..stage,
		burnt="burnt_"..stage,
		chop_burnt="chop_burnt_"..stage,
		idle_chop_burnt="idle_chop_burnt_"..stage,
		blown1="blown_loop_"..stage.."1",
		blown2="blown_loop_"..stage.."2",
		blown_pre="blown_pre_"..stage,
		blown_pst="blown_pst_"..stage
	}
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local old_anims =
{
	idle="idle_old",
	sway1="idle_old",
	sway2="idle_old",
	chop="chop_old",
	fallleft="chop_old",
	fallright="chop_old",
	stump="stump_old",
	burning="idle_olds",
	burnt="burnt_tall",
	chop_burnt="chop_burnt_tall",
	idle_chop_burnt="idle_chop_burnt_tall",
	blown="blown_loop",
	blown_pre="blown_pre",
	blown_pst="blown_pst"
}


local function dig_up_stump(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("tuber_crop")
end

local function set_stump(inst, push_anim)
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	inst:RemoveComponent("growable")
	inst:RemoveComponent("hackable")
	inst:RemoveComponent("bloomable")

	inst:RemoveComponent("blowinwindgust")

	RemovePhysicsColliders(inst)

	if push_anim then
		inst.AnimState:PushAnimation(inst.anims.stump)
	else
		inst.AnimState:PlayAnimation(inst.anims.stump)
	end

	inst.MiniMapEntity:SetIcon("tuber_trees_stump.png")

	inst:AddTag("stump")
	inst:RemoveTag("shelter")
	inst:RemoveTag("gustable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_stump)
	inst.components.workable:SetWorkLeft(1)
end

local function chop_down_burnt_tree(inst, chopper)
	inst:RemoveComponent("hackable")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
	inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
	RemovePhysicsColliders(inst)
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	if inst.pineconetask then
		inst.pineconetask:Cancel()
		inst.pineconetask = nil
	end
end

local function GetBuild(inst)
	local build = builds[inst.build]
	if build == nil then
		return builds["normal"]
	end
	return build
end

local function updateart(inst)
	for i,slot in ipairs(inst.tuberslots) do
		inst.AnimState:Hide("tubers"..slot)
	end

	for i=1,inst.tubers do
		inst.AnimState:Show("tubers"..inst.tuberslots[i])
	end
end

local burnt_highlight_override = {.5,.5,.5}
local function OnBurnt(inst, imm)
	local function changes()
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end

		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		inst:RemoveComponent("growable")
		inst:RemoveComponent("bloomable")
		inst:RemoveComponent("blowinwindgust")
		
		inst:RemoveTag("shelter")
		inst:RemoveTag("dragonflybait_lowprio")
		inst:RemoveTag("fire")
		inst:RemoveTag("gustable")

		inst.components.lootdropper:SetLoot({})

		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnWorkCallback(nil)
			inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
		end

		if inst.components.hackable then
			inst.components.hackable.onhackedfn = chop_down_burnt_tree
		end
	end

	if imm then
		changes()
	else
		inst:DoTaskInTime( 0.5, changes)
	end
	inst.AnimState:PlayAnimation(inst.anims.burnt, true)
	inst.MiniMapEntity:SetIcon("tuber_trees_burnt.png")
	--inst.AnimState:SetRayTestOnBB(true);
	inst:AddTag("burnt")

	inst.highlight_override = burnt_highlight_override
end

local function PushSway(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PushAnimation(inst.anims.sway2, true)
	end
end

local function Sway(inst)
	if math.random() > .5 then
		inst.AnimState:PlayAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PlayAnimation(inst.anims.sway2, true)
	end
	inst.AnimState:SetTime(math.random()*2)
end

local function SetShort(inst)
	inst.anims = short_anims
	inst.maxtubers = 2	
	inst.tuberslots = GetBuild(inst).tuberslots_short
	--[[
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.JUNGLETREE_CHOPS_SMALL)
	end
	]]
	--inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)

	Sway(inst)
end

local function GrowShort(inst)
	inst.AnimState:PlayAnimation("grow_tall_to_short")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/grow_pre")
	inst.tubers = math.min(inst.tubers, inst.maxtubers)
	updateart(inst)
	PushSway(inst)
end

local function SetTall(inst)
	inst.maxtubers = 3	
	inst.anims = tall_anims
	inst.tuberslots = GetBuild(inst).tuberslots_tall
	--[[
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.JUNGLETREE_CHOPS_TALL)
	end
	]]
	--inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)

	Sway(inst)
end

local function GrowTall(inst)
	inst.AnimState:PlayAnimation("grow_short_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/grow_pre")
	inst.tubers = math.min(inst.tubers + 1, inst.maxtubers)
	updateart(inst)
	PushSway(inst)
end

local function inspect_tree(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst:HasTag("stump") then
		return "CHOPPED"
	end
end

local growth_stages =
{
	{	
		name="short", 
	 	time = function(inst) return GetRandomWithVariance(TUNING.CLAWPALMTREE_GROW_TIME[1].base, TUNING.CLAWPALMTREE_GROW_TIME[1].random) end, 
	 	fn = function(inst) SetShort(inst) end,  
	 	growfn = function(inst) GrowShort(inst) end, 
	 	leifscale=.7 
	 },

	{
		name="tall", 
		time = function(inst) return GetRandomWithVariance(TUNING.CLAWPALMTREE_GROW_TIME[3].base, TUNING.CLAWPALMTREE_GROW_TIME[3].random) end, 
		fn = function(inst) SetTall(inst) end, 
		growfn = function(inst) GrowTall(inst) end, 
		leifscale=1.25 
	},	
}

local function tree_burnt(inst)
	OnBurnt(inst)
	inst.pineconetask = inst:DoTaskInTime(10,
		function()
			local pt = Vector3(inst.Transform:GetWorldPosition())
			if math.random(0, 1) == 1 then
				pt = pt + TheCamera:GetRightVec()
			else
				pt = pt - TheCamera:GetRightVec()
			end
			inst.components.lootdropper:DropLoot(pt)
			inst.pineconetask = nil
		end)
end

local function tree_lit(inst)
	DefaultIgniteFn(inst)
end

local function updateTreeType(inst)
	inst.AnimState:SetBuild(GetBuild(inst).file)
end

local function canbloom(inst)
	return not inst:HasTag("stump") and not inst:HasTag("burnt") and not inst:HasTag("rotten")
end

local function doTransformBloom(inst)
	if canbloom(inst) then
		inst.build = "blooming"
		inst.components.hackable.product = "tuber_bloom_crop"
		
		updateTreeType(inst)
	end
end

local function doTransformNormal(inst)
	if canbloom(inst) then	
		inst.build = "normal"
		if inst.components.hackable then
			inst.components.hackable.product = "tuber_crop"
		end
		updateTreeType(inst)
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	if inst.flushed then
		data.flushed = inst.flushed
	end

	if inst.tubers then
		data.tubers  = inst.tubers
	end

	if inst:HasTag("stump") then
		data.stump = true
	end

	if inst.build ~= "normal" then
		data.build = inst.build
	end
end

local function onload(inst, data)
	if data then
		if not data.build or builds[data.build] == nil then				
			doTransformNormal(inst)
		else
			inst.build = data.build
		end

		--[[
		if data.bloomtask then
            if inst.bloomtask then inst.bloomtask:Cancel() inst.bloomtask = nil end
            inst.bloomtaskinfo = nil
            inst.bloomtask, inst.bloomtaskinfo = inst:ResumeTask(data.bloomtask, function() doTransformBloom(inst) end)
        end   
        if data.unbloomtask then
            if inst.unbloomtask then inst.unbloomtask:Cancel() inst.unbloomtask = nil end
            inst.unbloomtaskinfo = nil
            inst.unbloomtask, inst.unbloomtaskinfo = inst:ResumeTask(data.unbloomtask, function() doTransformNormal(inst) end)
        end
		]]

		if data.flushed then
			inst.flushed = data.flushed
		end

		if data.tubers then
			inst.tubers = math.min(data.tubers, inst.maxtubers) -- inst.maxtubers is correctly set by growable component.
			updateart(inst)
		end

		if data.burnt then
			inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
			inst.MiniMapEntity:SetIcon("tuber_trees_burnt.png")

		elseif data.stump then
			set_stump(inst)
		end
	end
end

local function OnEntitySleep(inst)
	local fire = inst:HasTag("fire")

	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("inspectable")

	if fire then
		inst:AddTag("fire")
	end
end

local function OnEntityWake(inst)

	if not inst:HasTag("burnt") and not inst:HasTag("fire") then
		if not inst.components.burnable then
			if inst:HasTag("stump") then
				MakeSmallBurnable(inst)
			else
				MakeLargeBurnable(inst)
				inst.components.burnable:SetFXLevel(5)
				inst.components.burnable:SetOnBurntFn(tree_burnt)
			end
		end

		if not inst.components.propagator then
			if inst:HasTag("stump") then
				MakeSmallPropagator(inst)
			else
				MakeLargePropagator(inst)
				inst.components.burnable:SetOnIgniteFn(tree_lit)
			end
		end
	elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
		OnBurnt(inst, true)
	end

	if not inst.components.inspectable then
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree
	end
end

local function OnGustAnimDone(inst)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		inst:RemoveEventCallback("animover", OnGustAnimDone)
		return
	end
	if inst.components.blowinwindgust and inst.components.blowinwindgust:IsGusting() then
		local anim = math.random(1,2)
		inst.AnimState:PlayAnimation(inst.anims["blown"..tostring(anim)], false)
	else
		inst:DoTaskInTime(math.random()/2, function(inst)
            if not inst:HasTag("stump") and not inst:HasTag("burnt") then
                inst.AnimState:PlayAnimation(inst.anims.blown_pst, false)
                PushSway(inst)
            end
            inst:RemoveEventCallback("animover", OnGustAnimDone)
		end)
	end
end

local function OnGustStart(inst, windspeed)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		return
	end
	inst:DoTaskInTime(math.random()/2, function(inst)
		if inst:HasTag("stump") or inst:HasTag("burnt") then
			return
		end
		if inst.spotemitter == nil then
			AddToNearSpotEmitter(inst, "treeherd", "tree_creak_emitter", TUNING.TREE_CREAK_RANGE)
		end
		inst.AnimState:PlayAnimation(inst.anims.blown_pre, false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/wind_tree_creak")
		inst:ListenForEvent("animover", OnGustAnimDone)
	end)
end

local function OnGustEnd(inst, windspeed)
end

local function OnGustFall(inst)
	if inst:HasTag("burnt") then
		chop_down_burnt_tree(inst, GetPlayer())
	end
end

local function startbloom(inst)
	--inst.components.hackable.product = "tuber_bloom_crop"
	doTransformBloom(inst)
end

local function stopbloom(inst)
	--inst.components.hackable.product = "tuber_crop"
	doTransformNormal(inst)
end

local function onregenfn(inst)
	if not inst:HasTag("burnt") and not inst:HasTag("stump") then
		inst.tubers = math.min(inst.tubers + 1, inst.maxtubers)
		updateart(inst)
	end
end

local function onhackedfn(inst)
	inst.AnimState:PlayAnimation(inst.anims.chop)
	PushSway(inst)

	if inst.components.hackable.hacksleft <= 0 then
		inst.tubers = inst.tubers -1
	end

	updateart(inst)

	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/hit")
end

local function onhackedfinal(prefab,data)
	local inst = data.plant

	if inst.tubers < 0 then
	    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/tuber_fall")
		
		local he_right = math.random()>0.5 and true or false
		local pt = Vector3(inst.Transform:GetWorldPosition())

	    if data.hacker then
	    	local hispos = Vector3(data.hacker.Transform:GetWorldPosition())
	    	he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
		end
	    
	    if he_right then
	        inst.AnimState:PlayAnimation(inst.anims.fallleft)
	        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	    else
	        inst.AnimState:PlayAnimation(inst.anims.fallright)
	        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	    end

		set_stump(inst, true)

	    inst:AddTag("NOCLICK")
    	inst:DoTaskInTime(2, function() inst:RemoveTag("NOCLICK") end)
	end
end

local function makeemptyfn(inst)

end

local function makebarrenfn(inst)

end

--[[ local function onhammered(inst)
	if inst.tubers > 0 then
		while inst.tubers > 0 do
			inst.components.lootdropper:SpawnLootPrefab(inst.components.hackable.product)	
			inst.tubers = inst.tubers -1
		end		
	end
	inst.tubers = -1
	onhackedfinal(inst,{plant = inst})
	-- should process
end ]]

local function makefn(build, stage, data)

	local function fn(Sim)
		local l_stage = stage
		if l_stage == 0 then
			l_stage = math.random(1,3)
		end

		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()

		local sound = inst.entity:AddSoundEmitter()

		MakeObstaclePhysics(inst, .25)

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("tuber_trees.png")

		minimap:SetPriority(-1)

		inst:AddTag("plant")
		inst:AddTag("tree")
		inst:AddTag("workable")
		inst:AddTag("shelter")
		inst:AddTag("gustable")
		inst:AddTag("tubertree")

		inst.build = build
		anim:SetBuild(GetBuild(inst).file)
		anim:SetBank("tubertree")
		local color = 0.5 + math.random() * 0.5
		anim:SetMultColour(color, color, color, 1)

		-------------------

		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(3)
		inst.components.burnable:SetOnBurntFn(tree_burnt)
		inst.components.burnable:MakeDragonflyBait(1)
		
		-------------------

		MakeLargePropagator(inst)
		inst.components.burnable:SetOnIgniteFn(tree_lit)

		-------------------

		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree

		-------------------

		inst:AddComponent("hackable")
		inst.components.hackable:SetUp("tuber_crop", TUNING.VINE_REGROW_TIME )
		inst.components.hackable.onregenfn = onregenfn
		inst.components.hackable.onhackedfn = onhackedfn
		inst.components.hackable.makeemptyfn = makeemptyfn
		inst.components.hackable.makebarrenfn = makebarrenfn

		inst:ListenForEvent("hacked", onhackedfinal)

		inst.components.hackable.hacksleft = 3
		inst.components.hackable.maxhacks = 3
		inst.components.hackable.repeat_hack_cycle = true

		-------------------

		inst:AddComponent("lootdropper")

		---------------------
		
		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(l_stage)
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable:StartGrowing()

		--inst.growfromseed = handler_growfromseed

		inst:AddComponent("blowinwindgust")
		inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.JUNGLETREE_WINDBLOWN_SPEED)
		inst.components.blowinwindgust:SetDestroyChance(TUNING.JUNGLETREE_WINDBLOWN_FALL_CHANCE)
		inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
		--inst.components.blowinwindgust:SetGustEndFn(OnGustEnd)
		inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
		inst.components.blowinwindgust:Start()

		inst:AddComponent("mystery")

		---------------------

		inst:AddComponent("bloomable")
		inst.components.bloomable:SetCanBloom(canbloom)
		inst.components.bloomable:SetStartBloomFn(startbloom)
		inst.components.bloomable:SetStopBloomFn(stopbloom)
		inst.components.bloomable.season = {SEASONS.LUSH}

		---------------------
		--PushSway(inst)
		inst.AnimState:SetTime(math.random()*2)

		---------------------

		inst.OnSave = onsave
		inst.OnLoad = onload

		MakeSnowCovered(inst, .01)
		---------------------

		inst:SetPrefabName( GetBuild(inst).prefab_name )

		if data == "burnt"  then
			OnBurnt(inst)
		end

		if data == "stump"  then
			set_stump(inst)
		end

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake

		inst.tubers = inst.maxtubers
		updateart(inst)

		return inst
	end
	return fn
end

local function tree(name, build, stage, data)
	return Prefab("forest/objects/trees/"..name, makefn(build, stage, data), assets, prefabs)
end

return tree("tubertree", "normal", 0),
		tree("tubertree_tall", "normal", 2),
		tree("tubertree_short", "normal", 1),
		tree("tubertree_burnt", "normal", 0, "burnt"),
		tree("tubertree_stump", "normal", 0, "stump")
