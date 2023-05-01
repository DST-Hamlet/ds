local assets = 
{
	Asset("ANIM", "anim/goosemoose_nest_fx.zip")
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	inst.AnimState:SetBank("goosemoose_nest_fx")
	inst.AnimState:SetBuild("goosemoose_nest_fx")
	inst.AnimState:PlayAnimation("idle")

	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_electric")

	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

	return inst
end

return Prefab("moose_nest_fx", fn, assets)