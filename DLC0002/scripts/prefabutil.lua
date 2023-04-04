function MakePlacer(name, bank, build, anim, onground, snap, metersnap, scale, snap_to_flood, fixedcameraoffset, facing, hide_on_invalid, hide_on_ground, placeTestFn, preSetPrefabfn)
	     
	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(anim, true)
        inst.AnimState:SetLightOverride(1)


        if facing == "two" then
            inst.Transform:SetTwoFaced()
        elseif facing == "four" then
            inst.Transform:SetFourFaced()
        elseif facing == "six" then
            inst.Transform:SetSixFaced()
        elseif facing == "eight" then
            inst.Transform:SetEightFaced()
        end

		inst:AddTag("placer")        
		
		inst:AddComponent("placer")
		inst.persists = false
		inst.components.placer.snaptogrid = snap
		inst.components.placer.snap_to_meters = metersnap
		inst.components.placer.snap_to_flood= snap_to_flood
		inst.components.placer.fixedcameraoffset = fixedcameraoffset
		inst.components.placer.hide_on_invalid = hide_on_invalid
		inst.components.placer.hide_on_ground = hide_on_ground


		if placeTestFn then
			inst.components.placer.placeTestFn = placeTestFn
		end

		scale = scale or 1 
		inst.Transform:SetScale(scale, scale, scale)
		

		if onground then
			inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround)
		end
		
		if preSetPrefabfn then
			preSetPrefabfn(inst)
		end
				
		return inst
	end
	
	return Prefab(name, fn)
end

function AddToNearSpotEmitter(inst, tag, prefab, range)
	local x, y, z = inst.Transform:GetWorldPosition()
	local emitter = nil
	local emitters = TheSim:FindEntities(x, y, z, range or 20, {tag})
	if emitters then
		for k, v in pairs(emitters) do
			if not v.components.spotemitter:IsFull() then
				emitter = v
				break
			end
		end
	end
	if emitter == nil then
		--no emitter? make one
		--print("make emitter", prefab)
		emitter = SpawnPrefab(prefab)
	end
	if emitter then
		emitter.components.spotemitter:Add(inst)
	end
end
