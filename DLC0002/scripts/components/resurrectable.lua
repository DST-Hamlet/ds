
local Resurrectable = Class(function(self, inst)
    self.inst = inst
    self.cantdrown = nil
end)


function Resurrectable:FindClosestResurrector(cause)
	local res = nil
	local closest_dist = 0

	self.shouldwashuponbeach = false

	if cause == "drowning" then
		if self.resurrectionmethod == "amphibious" or self.resurrectionmethod == "ballphins" then
			self.shouldwashuponbeach = true
			
		elseif self.inst.components.inventory then
			local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if item then			
				if item.prefab == "armor_lifejacket"or item.prefab == "amulet" then
					self.shouldwashuponbeach = true				
				end				
			end
		end
	end

	if self.shouldwashuponbeach then
		--Find and return the closest beach resurrector 
		for k,v in pairs(Ents) do
			--print(v.prefab)
			if v.prefab == "beachresurrector" then
				local dist = v:GetDistanceSqToInst(self.inst)
				if not res or dist < closest_dist then
					res = v
					closest_dist = dist
				end
			end
		end

		if res then return res end
	else
		--Resurrect with amulet if you have one
		if self.inst.components.inventory then
			local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if item and item.prefab == "amulet" then
				return item
			end
		end

	end

	--Look for the closest ressurection point that can be used
	closest_dist = 0
	for k,v in pairs(Ents) do
		if v.components.resurrector and v.components.resurrector:CanBeUsed() then
			local dist = v:GetDistanceSqToInst(self.inst)
			if not res or dist < closest_dist then
				res = v
				closest_dist = dist
			end
		end
	end

	return res
end


function Resurrectable:CanResurrect(cause)
	self.resurrectionmethod = nil 

	if cause == "drowning" then 

		-- You are amphibious
		if self.cantdrown then
			self.resurrectionmethod = "amphibious"
			return true 
		end

		-- Ressurection Buddies
		if(self.inst.components.leader ~= nil) then
			for k,v in pairs(self.inst.components.leader.followers) do

				if k:HasTag("ballphin") and k:IsNear(self.inst, 32) then
					if math.random() < TUNING.BALLPHIN_DROWN_RESCUE_CHANCE then	
						self.resurrectionmethod = "ballphins"
						return true
					end
				end
			end
		end
	end 

	-- Ressurection Items
	if self.inst.components.inventory then
		local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if item then
			if item.prefab == "armor_lifejacket" and cause == "drowning" then
				self.resurrectionmethod = "lifejacket"
				return true
			end

			if item.prefab == "amulet" then
				self.resurrectionmethod = "amulet"
				return true
			end
		end
	end

	-- Other Resurrectors
	local res = false
	if SaveGameIndex:CanUseExternalResurector() then
		res = SaveGameIndex:GetResurrector() 
	end

	if res == nil or res == false then
		print("Looking at all the ents")
		for k,v in pairs(Ents) do
			if v.components.resurrector and v.components.resurrector:CanBeUsed() then
				self.resurrectionmethod = "resurrector"
				return true
			end
		end
	end

	if res then
		self.resurrectionmethod = "other"
		return true
	end

	return false
end

function TrySpawnSkeleton(inst, instant)
	if inst and inst.last_death_position then
	    local last_death_position = inst.last_death_position
		inst:DoTaskInTime(instant and 0 or 3, function(inst)
			if not inst:GetIsOnWater(last_death_position.x, last_death_position.y, last_death_position.z) then 
				local skel = SpawnPrefab("skeleton_player")
				if skel then
					skel.Transform:SetPosition(last_death_position.x, last_death_position.y, last_death_position.z)
				end
			end 
			inst.last_death_position = nil
		end)
	end
end

function Resurrectable:DoResurrect(res, cause)
    self.inst:PushEvent("resurrect")

	if self.shouldwashuponbeach then
		--Beach resurrection 
		res:doresurrect(self.inst)
		if self.inst.prefab == "woodie" then  --Woodie gets this flag set if he drowns due to transforming into the werebeaver, we need to change it back
			self.inst.AnimState:SetBank("wilson")
            self.inst.AnimState:SetBuild(self.inst.prefab)
			self.cantdrown = false 
		end 
	elseif res.prefab == "amulet" then
		--Execute Amulet Resurrect
		self.inst.sg:GoToState("amulet_rebirth")
		if self.inst.components.poisonable and self.inst.components.poisonable:IsPoisoned() then 
			self.inst.components.poisonable:Cure()
		end
		self.inst.last_death_position = nil
		--TrySpawnSkeleton(self.inst)
	else
		--External/Statue/Stone/etc
		res.components.resurrector:Resurrect(self.inst)
		if cause ~= "file_load" then TrySpawnSkeleton(self.inst) end
	end
end

return Resurrectable
