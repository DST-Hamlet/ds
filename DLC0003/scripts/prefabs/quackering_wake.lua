local assets =
{
    Asset( "ANIM", "anim/quackering_ram_splash.zip" ),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    anim:SetBuild("quackering_ram_splash")
    anim:SetBank("fx")

    anim:SetLayer(LAYER_BACKGROUND)
    anim:SetSortOrder(3)

    inst:DoTaskInTime(6*FRAMES, function() anim:PlayAnimation(inst.idleanimation) end)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

    inst:AddComponent("colourtweener")
    inst.components.colourtweener:StartTween({0,0,0,0}, FRAMES*30)

    return inst
end

return Prefab( "common/fx/quackering_wake", fn, assets )