local Fueled = Class(function(self, inst)
    self.inst = inst
    self.consuming = false
    
    self.maxfuel = 0
    self.currentfuel = 0
    self.rate = 1
    
    self.accepting = false
    self.fueltype = "BURNABLE"
    self.secondaryfueltype = nil
    self.sections = 1
    self.sectionfn = nil
    self.period = 1
    self.bonusmult = 1
    self.depleted = nil
    self.depletionmultiplier = 1
end)


function Fueled:MakeEmpty()
	if self.currentfuel > 0 then
		self:DoDelta(-self.currentfuel)
	end
end

function Fueled:OnSave()
    if self.currentfuel ~= self.maxfuel then
        return {fuel = self.currentfuel}
    end
end

function Fueled:OnLoad(data)
    if data.fuel then
        self:InitializeFuelLevel(data.fuel, true)
    end
end

function Fueled:SetSectionCallback(fn)
    self.sectionfn = fn
end

function Fueled:SetDepletedFn(fn)
    self.depleted = fn
end

function Fueled:IsEmpty()
    return self.currentfuel <= 0
end

function Fueled:SetSections(num)
    self.sections = num
end

function Fueled:CanAcceptFuelItem(item)

    if not self.accepting or not item or not item.components.fuel then
        return false
    end
    local gotfuel = false

    if item.components.fuel.fueltype == self.fueltype then
        gotfuel = true
    end

    if self.secondaryfueltype and item.components.fuel.fueltype == self.secondaryfueltype then
        gotfuel = true
    end

    if item.components.fuel.secondaryfueltype and item.components.fuel.secondaryfueltype == self.fueltype then
        gotfuel = true
    end

    if item.components.fuel.secondaryfueltype and self.secondaryfueltype and item.components.fuel.secondaryfueltype == self.secondaryfueltype then
        gotfuel = true
    end

    return gotfuel
end

function Fueled:GetCurrentSection()
    if self:IsEmpty() then
        return 0
    else
        return math.min( math.floor(self:GetPercent()* self.sections)+1, self.sections)
    end
end

function Fueled:ChangeSection(amount)
    local fuelPerSection = self.maxfuel / self.sections
    self:DoDelta((amount * fuelPerSection)-1)
end

function Fueled:TakeFuelItem(item)
    print("CAN ACCEPT FUEL",self:CanAcceptFuelItem(item))
    if self:CanAcceptFuelItem(item) then
        local oldsection = self:GetCurrentSection()
    
        -- self.currentfuel = self.currentfuel + (item.components.fuel.fuelvalue * self.bonusmult)
        -- if self.currentfuel > self.maxfuel then
        --     self.currentfuel = self.maxfuel
        -- end

        local moisturemgr = GetWorld().components.moisturemanager
        local fuelamt = item.components.fuel.fuelvalue * self.bonusmult
        if moisturemgr and not moisturemgr:IsEntityDry(item) then
            fuelamt = fuelamt * TUNING.WET_FUEL_PENALTY
        end
        self:DoDelta(fuelamt)

        if item.components.fuel then
            item.components.fuel:Taken(self.inst)
        end
        item:Remove()
        
        if self.sections > 1 and self.sectionfn then
        
            local newsection = self:GetCurrentSection()
            if oldsection ~= newsection then
                self.sectionfn(newsection,oldsection, self.inst)
            end
            
        end
        
        if self.ontakefuelfn then
            self.ontakefuelfn(self.inst, item)
        end
        
        return true
    end
    
end


function Fueled:SetUpdateFn(fn)
    self.updatefn = fn
end

function Fueled:GetDebugString()

    local section = self:GetCurrentSection()
    
    return string.format("%s %2.2f/%2.2f (-%2.2f) : section %d/%d %2.2f", self.consuming and "ON" or "OFF", self.currentfuel, self.maxfuel, self.rate, section, self.sections, self:GetSectionPercent())
end

function Fueled:AddThreshold(percent, fn)
    table.insert(self.thresholds, {percent=percent, fn=fn})
    --table.sort(self.thresholds, function(l,r) return l.percent < r.percent)
end

function Fueled:GetSectionPercent()
    local section = self:GetCurrentSection()
    return (self:GetPercent() - (section - 1)/self.sections) / (1/self.sections)
end

function Fueled:GetPercent()
    if self.maxfuel > 0 then 
        return math.min(1, self.currentfuel / self.maxfuel)
    else
        return 0
    end
end

function Fueled:SetPercent(amount)
    local target = (self.maxfuel * amount)
    self:DoDelta(target - self.currentfuel)
end

function Fueled:StartConsuming()
    self.consuming = true
    if self.task == nil then
        self.task = self.inst:DoPeriodicTask(self.period, function() self:DoUpdate(self.period) end)
    end
end

function Fueled:InitializeFuelLevel(fuel, isload)
    local oldsection = self:GetCurrentSection()
    if self.maxfuel < fuel then
        self.maxfuel = fuel
    end
    self.currentfuel = fuel
    
    local newsection = self:GetCurrentSection()
    if oldsection ~= newsection and self.sectionfn then
        self.sectionfn(newsection, oldsection, self.inst, isload)
    end
end

function Fueled:DoDelta(amount)
    local oldsection = self:GetCurrentSection()
    
    amount = amount * self.depletionmultiplier
    self.currentfuel = math.max(0, math.min(self.maxfuel, self.currentfuel + amount) )
    
    local newsection = self:GetCurrentSection()
    
    if oldsection ~= newsection then
        if self.sectionfn then
            self.sectionfn(newsection,oldsection, self.inst)
        end
        if self.currentfuel <= 0 and self.depleted then
            self.depleted(self.inst)
        end
    end

    self.inst:PushEvent("percentusedchange", {percent = self:GetPercent(), fuel = self.currentfuel})
end

function Fueled:DoUpdate( dt )
    if self.consuming then
        self:DoDelta(-dt*self.rate)
    end
    
    if self:IsEmpty() then
        self:StopConsuming()
    end
    
    if self.updatefn then
        self.updatefn(self.inst)
    end

end

function Fueled:StopConsuming()
    self.consuming = false
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

function Fueled:LongUpdate(dt)
	self:DoUpdate(dt)
end

return Fueled

