local function makeassetlist()
    return {
		Asset("ANIM", "anim/teleportato_shipwrecked_parts.zip"),
		Asset("ANIM", "anim/teleportato_parts_build.zip"),
		Asset("ANIM", "anim/teleportato_adventure_parts_build.zip"),
    }
end

local function makefn(name, frame)
    local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()

		MakeInventoryPhysics(inst)
		
		anim:SetBank("parts")
		
		anim:PlayAnimation(frame, false)
		MakeInventoryFloatable(inst, frame.."_water", frame)
		
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")

        if SaveGameIndex:GetCurrentMode(Settings.save_slot) == "adventure" then
	        anim:SetBuild("teleportato_adventure_parts_build")
	        inst.components.inventoryitem:ChangeImageName(name.."_adv")
	    else
	        anim:SetBuild("teleportato_shipwrecked_parts")
	    end
	    
		inst:AddComponent("tradable")
        
		inst:AddTag("irreplaceable")
		inst:AddTag("dropontravel")
		inst:AddTag("teleportato_part")

       	return inst
	end
    return fn
end

local function TeleportatoPart(name, frame)
    return Prefab( "common/inventory/" .. name, makefn(name, frame), makeassetlist())
end

return TeleportatoPart( "teleportato_sw_ring", "ring"),
		TeleportatoPart( "teleportato_sw_box", "lever"),
		TeleportatoPart( "teleportato_sw_crank", "support"), 
		TeleportatoPart( "teleportato_sw_potato", "potato") 
