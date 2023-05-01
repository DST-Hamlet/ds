

local assets =
{
	Asset("ANIM", "anim/wind_fx.zip")
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    --inst.entity:AddPhysics()
    anim:SetBuild( "wind_fx" )
    anim:SetBank( "wind_fx" )
    anim:SetOrientation(ANIM_ORIENTATION.OnGround)
	anim:PlayAnimation( "side_wind_loop", true )
	
	inst:AddTag( "FX" )
	inst:AddTag( "NOCLICK" )

	inst:AddComponent("windfx")

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

    return inst
end

return Prefab( "common/fx/windswirl", fn, assets, nil)