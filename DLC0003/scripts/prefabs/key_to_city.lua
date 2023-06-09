local assets =
{
	Asset("ANIM", "anim/key_to_city.zip"),
    Asset("INV_IMAGE", "key_to_city"),
}

    local function OnTurnOn(inst)
        inst.components.prototyper.on = true  -- prototyper doesn't set this until after this function is called!!
    end
    local function OnTurnOff(inst)
        inst.components.prototyper.on = false  -- prototyper doesn't set this until after this function is called
    end

local function canCurrentlyPrototypeTestFn(inst)
    return not TheCamera.interior
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")
 
    inst.AnimState:SetBank("keytocity")
    inst.AnimState:SetBuild("key_to_city")
    inst:AddTag("prototyper")
    inst:AddTag("no_interior_protoyping")
    inst:AddTag("irreplaceable")

    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
    inst.components.prototyper.onturnoff = OnTurnOff    
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.CITY
    inst.components.prototyper.craftingstation = true
        inst.components.prototyper.onactivate = function()
           -- inst.AnimState:PlayAnimation("use")
           -- inst.AnimState:PushAnimation("idle")
           -- inst.AnimState:PushAnimation("proximity_loop", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_run","sound")

            inst:DoTaskInTime(1.5, function() 
                inst.SoundEmitter:KillSound("sound")
                inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding","sound")     
            end)
        end
    inst.components.prototyper:SetCanPrototypeTestFunction(canCurrentlyPrototypeTestFn)

    return inst
end

return Prefab( "common/inventory/key_to_city", fn, assets)

