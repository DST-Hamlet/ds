local normalassets = {
    Asset("ANIM", "anim/antler.zip"),
    Asset("ANIM", "anim/swap_antler.zip"),
    Asset("INV_IMAGE", "antler"),
}

local corruptedassets = {
    Asset("ANIM", "anim/antler_corrupted.zip"),
    Asset("ANIM", "anim/swap_antler_corrupted.zip"),
    Asset("INV_IMAGE", "antler_corrupted"),
}

local function OnPlayedNormal(inst, musician)
    local rocmanager = GetWorld().components.rocmanager
    if not TheCamera.interior and rocmanager then
        rocmanager:Spawn()
    end
end

local function OnPlayedCorrupted(inst, musician)
    musician.SoundEmitter:PlaySound("ancientguardian_rework/tentacle_shadow/voice_appear")
    musician.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")

    local rocmanager = GetWorld().components.rocmanager
    if rocmanager then
        rocmanager:Disable()
    end

    inst:Remove()
end

local function CommonFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("horn")

    inst.AnimState:SetBank("antler")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")

    inst:AddComponent("inspectable")

    inst:AddComponent("instrument")
    inst.components.instrument.range = 0
    inst.components.instrument.sound_noloop = "dontstarve_DLC003/common/crafted/roc_flute"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("inventoryitem")

    return inst
end

local function NormalFn()
    local inst = CommonFn()

    inst.AnimState:SetBuild("antler")

    inst.components.instrument.onplayed = OnPlayedNormal

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.BIRDWHISLE_USES)
    inst.components.finiteuses:SetUses(TUNING.BIRDWHISLE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)

    inst.hornsymbol = "swap_antler"
    inst.hornbuild = "swap_antler"

    return inst
end

local function CorruptedFn()
    local inst = CommonFn()

    inst.AnimState:SetBuild("antler_corrupted")

    inst.components.instrument.onplayed = OnPlayedCorrupted

    inst.hornbuild = "swap_antler_corrupted"
    inst.hornsymbol = "swap_antler_corrupted"

    return inst
end

return
    Prefab("common/inventory/antler",           NormalFn,    normalassets   ),
    Prefab("common/inventory/antler_corrupted", CorruptedFn, corruptedassets)

