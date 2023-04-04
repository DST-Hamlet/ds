local assets =
{
	Asset( "ANIM", "anim/splash_hail.zip" ),
	Asset( "ANIM", "anim/hail.zip" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    anim:SetBuild( "splash_hail" )
    anim:SetBank( "splash_hail" )
	anim:PlayAnimation( "idle" ) 
	
	inst:AddTag( "FX" )

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

    return inst
end

return Prefab( "common/fx/haildrop", fn, assets ) 
 
