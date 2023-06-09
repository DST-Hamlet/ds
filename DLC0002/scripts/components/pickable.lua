local activelisteners = 0

local Pickable = Class(function(self, inst)
    self.inst = inst
    self.canbepicked = nil
    self.hasbeenpicked = nil
    self.regentime = nil
    self.baseregentime = nil
    self.product = nil
    self.onregenfn = nil
    self.onpickedfn = nil
    self.makeemptyfn = nil
    self.makefullfn = nil
    self.makebarrenfn = nil
    self.cycles_left = nil
    self.transplanted = false
    self.caninteractwith = true
    self.numtoharvest = 1
 
	self.paused = false
    self.pause_time = 0

    self.protected_cycles = nil
    self.wither_time = nil
    self.withered = false
    self.shouldwither = false
    self.witherable = false
    self.protected = false
    self.wildfirestarter = false

	self.highfertilizerconsumer = false

    self.reverseseasons = nil

    if SaveGameIndex:GetCurrentMode() == "volcano" or SaveGameIndex:GetCurrentMode() == "shipwrecked" then
        self.wither_temp = math.random(TUNING.SW_MIN_PLANT_WITHER_TEMP, TUNING.SW_MAX_PLANT_WITHER_TEMP)
    	self.rejuvenate_temp = math.random(TUNING.SW_MIN_PLANT_REJUVENATE_TEMP, TUNING.SW_MAX_PLANT_REJUVENATE_TEMP)
    else
        self.wither_temp = math.random(TUNING.MIN_PLANT_WITHER_TEMP, TUNING.MAX_PLANT_WITHER_TEMP)
    	self.rejuvenate_temp = math.random(TUNING.MIN_PLANT_REJUVENATE_TEMP, TUNING.MAX_PLANT_REJUVENATE_TEMP)
    end

	self.witherHandler = function(it, data)
		local tempcheck = false
		if self.reverseseasons then			
			tempcheck = data.temp <= self.rejuvenate_temp
		else
			tempcheck = data.temp > self.wither_temp
		end

    	if self.witherable and not self.withered and not self.protected and tempcheck and 
    	   (self.protected_cycles == nil or self.protected_cycles < 1) then
    		self.withered = true
    		self.inst:AddTag("withered")
    		self.wither_time = GetTime()    	
    		self:MakeBarren()
    	end
    end
	self.rejuvenateHandler = function(it, data)
		local tempcheck = false
		if self.reverseseasons then
			tempcheck = data.temp >= self.wither_temp
		else
			tempcheck = data.temp < self.rejuvenate_temp
		end

		if tempcheck then
	    	local time_since_wither = GetTime()
	    	if self.wither_time then 
	    		time_since_wither = time_since_wither - self.wither_time
	    	else
	    		time_since_wither = TUNING.TOTAL_DAY_TIME
	    	end
	    	if self.withered and time_since_wither >= TUNING.TOTAL_DAY_TIME then
	    		if self.cycles_left and self.cycles_left <= 0 then
	    			self:MakeBarren()
	    		else
	    			self:MakeEmpty()
	    		end
	    		self.withered = false
	    		self.inst:RemoveTag("withered")
	    		self.shouldwither = false
	    		self.witherable = true
	    		self.inst:AddTag("witherable")
	    	elseif self.shouldwither and time_since_wither >= TUNING.TOTAL_DAY_TIME then
	    		self.shouldwither = false
	    		self.witherable = true
	    		self.inst:AddTag("witherable")
	    	end
	    end
	end
end)

function Pickable:CheckPlantState()
	local data = { temp = GetSeasonManager():GetCurrentTemperature() }
	self:witherHandler(data)
	self:rejuvenateHandler(data)
end

function Pickable:StartListeningToEvents()
	if self.reverseseasons then
	    self.inst:ListenForEvent("witherplants", self.rejuvenateHandler, GetWorld())
	    self.inst:ListenForEvent("rejuvenateplants", self.witherHandler, GetWorld())
	else
	    self.inst:ListenForEvent("witherplants", self.witherHandler, GetWorld())
	    self.inst:ListenForEvent("rejuvenateplants", self.rejuvenateHandler, GetWorld())
	end
end

function Pickable:StopListeningToEvents()
	if self.reverseseasons then
	    self.inst:RemoveEventCallback("witherplants", self.rejuvenateHandler, GetWorld())
	    self.inst:RemoveEventCallback("rejuvenateplants", self.witherHandler, GetWorld())
	else
		self.inst:RemoveEventCallback("witherplants", self.witherHandler, GetWorld())
    	self.inst:RemoveEventCallback("rejuvenateplants", self.rejuvenateHandler, GetWorld())
    end
end

function Pickable:SetReverseSeasons(reverse)
	self:StopListeningToEvents()
	self.reverseseasons = reverse
	self:StartListeningToEvents()
end

function Pickable:OnEntitySleep()
	self:StopListeningToEvents()
end

function Pickable:OnEntityWake()
	self:CheckPlantState()
	self:StartListeningToEvents()
end


function Pickable:LongUpdate(dt)

	if not self.paused and self.targettime and not self.withered then
	
		if self.task then 
			self.task:Cancel()
			self.task = nil
		end
	
	    local time = GetTime()
		if self.targettime > time + dt then
	        --resechedule
	        local time_to_pickable = self.targettime - time - dt
	        time_to_pickable = time_to_pickable * self:GetGrowthMod() --if GetSeasonManager():IsSpring() then time_to_pickable = time_to_pickable * TUNING.SPRING_GROWTH_MODIFIER end
			self.task = self.inst:DoTaskInTime(time_to_pickable, OnRegen, "regen")
			self.targettime = time + time_to_pickable
	    else
			--become pickable right away
			self:Regen()
	    end
	end
end

function Pickable:IsWithered()
	return self.withered
end

function Pickable:MakeWitherable()
	self.witherable = true
	self.inst:AddTag("witherable")
end

function Pickable:Rejuvenate(fertilizer)
	if self.protected_cycles >= 0 then
		self.withered = false
		self.inst:RemoveTag("withered")
		self.witherable = false
		self.inst:RemoveTag("witherable")
		self.shouldwither = true

		self.cycles_left = self.max_cycles
		self:MakeEmpty()
	else
		GetPlayer():PushEvent("insufficientfertilizer")
	end
end

function Pickable:IsWildfireStarter()
	return (self.wildfirestarter == true or self.withered == true)
end

function Pickable:FinishGrowing()
	if not self.canbepicked and not self.withered then
		if self.task then
			self.task:Cancel()
			self.task = nil	
			self:Regen()
		end
	end
end

function Pickable:Resume()
	if self.paused then
		self.paused = false
		if not self.canbepicked and (not self.cycles_left or self.cycles_left > 0) then
		
			if self.pause_time then
				self.pause_time = self.pause_time * self:GetGrowthMod() --if GetSeasonManager():IsSpring() then self.pause_time = self.pause_time * TUNING.SPRING_GROWTH_MODIFIER end
				self.task = self.inst:DoTaskInTime(self.pause_time, OnRegen, "regen")
				self.targettime = GetTime() + self.pause_time
			else
				self:MakeEmpty()
			end
			
		end
	end
end

function Pickable:Pause()
	
	if self.paused == false then
		self.pause_time = nil
		self.paused = true
		
		if self.task then
			self.task:Cancel()
			self.task = nil	
		end
		
		if self.targettime then
			self.pause_time = math.max(0, self.targettime - GetTime())
		end
	end
end


function Pickable:GetDebugString()
	local time = GetTime()

	local str = ""
	--if self.caninteractwith then
		--str = "caninteractwith"
	if self.paused then
		str = "paused"
		if self.pause_time then
			str = str.. string.format(" %2.2f", self.pause_time)
		end
	elseif self.transplanted then
		str = "cycles:" .. tostring(self.cycles_left) .. " / " .. tostring(self.max_cycles)
		if self.targettime and self.targettime > time then
			str = str.." Regen in:" ..  tostring(math.floor(self.targettime - time))
		end
	else
		str = "Not transplanted "
		if self.targettime and self.targettime > time then
			str = str.." Regen in:" ..  tostring(math.floor(self.targettime - time))
		else
			str = str.."Should have regened "
			if self.targettime then 
				str = str.. "Target time is " .. self.targettime
			end 
			str = str.. "current time is ".. time
		end

	end
	str = str .. " || withertemp: " .. self.wither_temp .. " rejuvtemp: " .. self.rejuvenate_temp
	return str
end

function Pickable:GetGrowthMod()
	local mod = 1.0
	local sm = GetSeasonManager()
	if sm and (sm:IsSpring() or sm:IsGreenSeason()) then
		mod = TUNING.SPRING_GROWTH_MODIFIER
	end
	return mod
end

function Pickable:SetUp(product, regen, number)
    self.canbepicked = true
    self.hasbeenpicked = false
    self.product = product
    self.baseregentime = regen
    self.regentime = regen
    self.numtoharvest = number or 1
end

function Pickable:SetOnPickedFn(fn)
	self.onpickedfn = fn
end

function Pickable:SetOnRegenFn(fn)
	self.onregenfn = fn
end

function Pickable:SetMakeBarrenFn(fn)
	self.makebarrenfn = fn
end

function Pickable:SetMakeEmptyFn(fn)
	self.makeemptyfn = fn
end

function Pickable:CanBeFertilized()
	if self.fertilizable ~= false and self.cycles_left == 0 then
		return true
	end
	if self.fertilizable ~= false and self.withered then--(self.withered or self.shouldwither) then
		return true
	end
end

function Pickable:Fertilize(fertilizer, doer)
    if self.inst.components.burnable ~= nil then
        self.inst.components.burnable:StopSmoldering()
    end

    if fertilizer.components.finiteuses then
        fertilizer.components.finiteuses:Use()
    else
        fertilizer.components.stackable:Get(1):Remove()
    end

	local fertilize_cycles = fertilizer.components.fertilizer ~= nil and fertilizer.components.fertilizer.withered_cycles or 0

    self.protected_cycles = (self.protected_cycles or 0) + fertilize_cycles

	if not self.highfertilizerconsumer then
		self.protected_cycles = math.max(self.protected_cycles, 0)
	end

	if self.withered then
		self:Rejuvenate(fertilizer)
		return
	end

	self.cycles_left = self.max_cycles
	self:MakeEmpty()
end

function Pickable:OnSave()
	
	local data = { 
		withered = self.withered,
		shouldwither = self.shouldwither,
		protected_cycles = self.protected_cycles,
		picked = not self.canbepicked and true or nil, 
		transplanted = self.transplanted and true or nil,
		paused = self.paused and true or nil,
		caninteractwith = self.caninteractwith and true or nil,
		--pause_time = self.pause_time 
	}

	if self.cycles_left ~= self.max_cycles then
		data.cycles_left = self.cycles_left
		data.max_cycles = self.max_cycles 
	end
	
	if self.pause_time and self.pause_time > 0 then
		data.pause_time = self.pause_time
	end
	
	if self.targettime then
	    local time = GetTime()
		if self.targettime > time then
	        data.time = math.floor(self.targettime - time)
	    end
	end
	
    if next(data) then
		return data
	end
	
end

function Pickable:OnLoad(data)

	self.transplanted = data.transplanted or false
	
	self.cycles_left = data.cycles_left or self.cycles_left
	self.max_cycles = data.max_cycles or self.max_cycles
	
	if data.picked or data.time then
        if self.cycles_left == 0 and self.makebarrenfn then
			self.makebarrenfn(self.inst)
        elseif self.makeemptyfn then
			self.makeemptyfn(self.inst)
		end
        self.canbepicked = false
        self.hasbeenpicked = true
	else
		if self.makefullfn then
			self.makefullfn(self.inst)
		end
		self.canbepicked = true
		self.hasbeenpicked = false
	end
    
    if data.caninteractwith then
    	self.caninteractwith = data.caninteractwith
    end

    if data.paused then
		self.paused = true
		self.pause_time = data.pause_time
    else
		if data.time then
			self.task = self.inst:DoTaskInTime(data.time, OnRegen, "regen")
			self.targettime = GetTime() + data.time
		end
	end    

	if data.makealwaysbarren == 1 then
		if self.makebarrenfn then
			self:MakeBarren()
		end
	end

	self.withered = data.withered
	self.shouldwither = data.shouldwither
	self.protected_cycles = data.protected_cycles
	if self.withered then
		self:MakeBarren()
	end
end

function Pickable:IsBarren()
	return self.cycles_left and self.cycles_left == 0
end

function Pickable:CanBePicked()
    return self.canbepicked
end

function OnRegen(inst)
	if inst.components.pickable then
		inst.components.pickable:Regen()
	end
end

function Pickable:Regen()
    self.canbepicked = true
    self.hasbeenpicked = false

	self.targettime = nil
    self.task = nil

    if self.onregenfn then
        self.onregenfn(self.inst)
    end
    if self.makefullfn then
    	self.makefullfn(self.inst)
    end
end

function Pickable:MakeBarren()
	if not self.withered then 
		self.cycles_left = 0
	end
    self.canbepicked = false
    if self.task then
		self.task:Cancel()
    end
    
	if self.makebarrenfn then
		self.makebarrenfn(self.inst)
	end
end

function Pickable:OnTransplant()
	self.transplanted = true
	
	if self.ontransplantfn then
		self.ontransplantfn(self.inst)
	end
end

function Pickable:MakeEmpty()
    if self.task then
		self.task:Cancel()
    end
    
	if self.makeemptyfn then
		self.makeemptyfn(self.inst)
	end

    self.canbepicked = false
    
	if not self.paused then
		if self.baseregentime then
			local time = self.baseregentime
			
			if self.getregentimefn then
				time = self.getregentimefn(self.inst)
			end
			
			time = time * self:GetGrowthMod() --if GetSeasonManager():IsSpring() then time = time * TUNING.SPRING_GROWTH_MODIFIER end
			self.task = self.inst:DoTaskInTime(time, OnRegen, "regen")
			self.targettime = GetTime() + time
		end
	end
end

function Pickable:Pick(picker)
    if self.canbepicked and self.caninteractwith then

		if self.transplanted then
			if self.cycles_left ~= nil then
				self.cycles_left = self.cycles_left - 1
			end
		end

		if self.protected_cycles ~= nil then
			self.protected_cycles = self.protected_cycles - 1
			if self.protected_cycles <= 0 then
                if not self:IsWithered() then
                    self:MakeWitherable()
                end
            end
		end
		
		local loot = nil
        if picker and picker.components.inventory and self.product then
            loot = SpawnPrefab(self.product)

            if loot then
	            if self.numtoharvest > 1 and loot.components.stackable then
	            	loot.components.stackable:SetStackSize(self.numtoharvest)	            	
	            end

				self.inst:ApplyInheritedMoisture(loot)

		        picker:PushEvent("picksomething", {object = self.inst, loot= loot})
                picker.components.inventory:GiveItem(loot, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
            end
        end
        
        if self.onpickedfn then
            self.onpickedfn(self.inst, picker, loot)
        end
        
        self.canbepicked = false
        self.hasbeenpicked = true
        
        if not self.paused and not self.withered and self.baseregentime and (self.cycles_left == nil or self.cycles_left > 0) then
        	self.regentime = self.baseregentime * self:GetGrowthMod() --if GetSeasonManager():IsSpring() then self.regentime = self.baseregentime * TUNING.SPRING_GROWTH_MODIFIER end
			self.task = self.inst:DoTaskInTime(self.regentime, OnRegen, "regen")
			self.targettime = GetTime() + self.regentime
		end
        
        self.inst:PushEvent("picked", {picker = picker, loot = loot, plant = self.inst})
    end
end


function Pickable:CollectSceneActions(doer, actions)
    if self.canbepicked and self.caninteractwith and not (self.inst.components.burnable and self.inst.components.burnable:IsBurning()) then
        table.insert(actions, ACTIONS.PICK)
    end
end

return Pickable
