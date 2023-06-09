require "prefabutil"
local assets=
{
    Asset("ANIM", "anim/musselfarm_seed.zip"),
}


local prefabs = 
{
    "mussel_farm",
}

local function ondeploy(inst, pt)
    inst = inst.components.stackable:Get()
    inst:Remove()

    local farm = SpawnPrefab("mussel_farm")
    farm.Transform:SetPosition(pt:Get())

    farm.components.growable:SetStage(2)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/muscle_plant")

    return farm
end

local function stopgrowing(inst)
    if inst.growtask then
        inst.growtask:Cancel()
        inst.growtask = nil
    end
    inst.growtime = nil
end

local function restartgrowing(inst)
    if inst and not inst.growtask then
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.growtime = GetTime() + growtime
        inst.growtask = inst:DoTaskInTime(growtime, growtree)
    end
end


local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype == GROUND.OCEAN_SHALLOW 
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function describe(inst)
    if inst.growtime then
        return "PLANTED"
    end
end

local function OnSave(inst, data)
    if inst.growtime then
        data.growtime = inst.growtime - GetTime()
    end
end

local function OnLoad(inst, data)
    if data and data.growtime then
        plant(inst, data.growtime)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

    inst.AnimState:SetBank("musselfarm_seed")
    inst.AnimState:SetBuild("musselfarm_seed")
    inst.AnimState:PlayAnimation("idle")
    
    MakeInventoryFloatable(inst, "idle_water", "idle")

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = describe
        
    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy
    
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab( "common/inventory/mussel_bed", fn, assets, prefabs),
       MakePlacer( "common/mussel_bed_placer", "musselfarm", "musselfarm", "idle_underwater") 




