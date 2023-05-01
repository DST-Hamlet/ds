local assets =
{
	Asset( "ANIM", "anim/action_lines.zip" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	--trans:SetFourFaced()

    local anim = inst.entity:AddAnimState()
    
    anim:SetBuild("action_lines")
   	anim:SetBank( "action_lines" )
   	anim:SetOrientation( ANIM_ORIENTATION.OnGround )
	--anim:SetLayer(LAYER_BACKGROUND )
	anim:SetSortOrder( 3 )
	anim:PlayAnimation( "idle_loop", false ) 

	--inst:Hide()
	inst:AddTag( "FX" )
	inst:AddTag( "NOCLICK")
	
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

    return inst
end

return Prefab( "common/fx/windtrail", fn, assets ) 
 
