local assets = 
{
	Asset("ANIM", "anim/skeletons.zip"),
}

local prefabs =
{
	"boneshard",
	"collapse_small",
}

SetSharedLootTable( 'skeleton',
{
    {'boneshard',	1.00},
    {'boneshard',	1.00},
})

local animstates = {1, 3, 4, 5, 6} --not going to use the spear skeleton until anim to take spear is made

local function onsave(inst, data)
	data.anim = inst.animnum
end

local function onload(inst, data)
	if data then
		if data.anim then
			inst.animnum = data.anim
			inst.AnimState:PlayAnimation("idle"..inst.animnum)
		end
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function fn()

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 0.25)

	inst.animnum = animstates[math.random(#animstates)]
	anim:SetBank("skeleton")
	anim:SetBuild("skeletons")
	anim:PlayAnimation("idle"..inst.animnum)

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('skeleton') 

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	inst.OnLoad = onload
	inst.OnSave = onsave

	return inst
end

local function playerskel()
	local inst = fn()
	return inst
end

function SpawnPlayerSkeletonHidden(position)
	local skel = SpawnPrefab("skeleton_player")

	if skel:GetIsOnWater(position.x, position.y, position.z) then 
		skel:Remove()
		return
	end

	skel.Physics:SetActive(false)
	skel:Hide()
	skel.HiddenPlayerSkeleton = true

	skel.Transform:SetPosition(position.x, position.y, position.z)
end

return Prefab("common/objects/skeleton", fn, assets, prefabs),
	Prefab("common/objects/skeleton_player", playerskel, assets, prefabs)
