local BlinkStaff = Class(function(self, inst)
    self.inst = inst
    self.onblinkfn = nil
    self.blinkdistance_controller = 13 
end)

function BlinkStaff:GetBlinkPoint()
	--For use with controller.


	local owner = self.inst.components.inventoryitem.owner
	if not owner then return end
	local pt = nil
	local rotation = owner.Transform:GetRotation()*DEGREES
	local pos = owner:GetPosition()

	for r = self.blinkdistance_controller, 1, -1 do
        local numtries = 2*PI*r

        if owner:HasTag("aquatic") then
        	pt = FindWaterOffset(pos, rotation, r, numtries)
        else
			pt = FindGroundOffset(pos, rotation, r, numtries)
        end

		if pt then
			return pt + pos
		end
	end
end

function BlinkStaff:CanBlinkToPoint(pt)
    local ground = GetWorld()
    if ground then
		local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
		return tile ~= GROUND.IMPASSABLE and tile < GROUND.UNDERGROUND and IsPointInInteriorBounds(pt)
	end
	return false
end

function BlinkStaff:CollectPointActions(doer, pos, actions, right)
    if right then
    	--print(GetTick(), "Testing Action")

    	if self.target_position then
    		pos = self.target_position
    	end
		if self:CanBlinkToPoint(pos) then
			--print(GetTick(), "Inserting Action")
			table.insert(actions, ACTIONS.BLINK)
		end
	end
end

function BlinkStaff:SpawnEffect(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("sand_puff_large_back").Transform:SetPosition(x, y - .1, z)
    SpawnPrefab("sand_puff_large_front").Transform:SetPosition(x, y, z)
end

function BlinkStaff:Blink(pt, caster)
	if self:CanBlinkToPoint(pt) == false then
		return false
	end

	self:SpawnEffect(caster)
	caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
	caster:Hide()
	if caster.components.health then
		caster.components.health:SetInvincible(true)
	end
	caster:DoTaskInTime(0.25, function() 
		if caster.components.health then
			caster.components.health:SetInvincible(false)
		end
		caster.Transform:SetPosition(pt.x, pt.y, pt.z)
		self:SpawnEffect(caster)
		caster:Show()
		caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
		end)
	
	--TheCamera:Snap()
	if self.onblinkfn then
		self.onblinkfn(self.inst, pt, caster)
	end
	return true
end

return BlinkStaff
