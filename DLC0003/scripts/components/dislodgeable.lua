local Dislodgeable = Class(function(self, inst)
    self.inst = inst
    self.canbedislodged = nil
    self.hasbeendislodged = nil
    self.product = nil
    self.ondislodgedfn = nil
    self.canbedislodgedfn = nil
    self.caninteractwith = true
    self.numtoharvest = 1
    self.dropsymbol = nil
end)

function Dislodgeable:SetUp(product, number)
    self.canbedislodged = true
    self.hasbeendislodged = false
    self.product = product
    self.numtoharvest = number
end

function Dislodgeable:SetOnDislodgedFn(fn)
    self.ondislodgedfn = fn
end

function Dislodgeable:SetCanBeDislodgedFn(fn)
    self.canbedislodgedfn = fn
end

function Dislodgeable:SetDropFromSymbol(symbolname)
    self.dropsymbol = symbolname
end

function Dislodgeable:OnSave()
    local data = { 
        hasbeendislodged = self.hasbeendislodged,
        caninteractwith = self.caninteractwith,
    }

    if next(data) then
        return data
    end
    
end

function Dislodgeable:OnLoad(data)
    if data.caninteractwith then
        self.caninteractwith = data.caninteractwith
    end

    if data.hasbeendislodged then 
        self.hasbeendislodged = data.hasbeendislodged
    end
end

function Dislodgeable:GetLootDropPosition()
    return self.dropsymbol and Vector3(self.inst.AnimState:GetSymbolPosition(self.dropsymbol, 0,0,0)) or nil
end

function Dislodgeable:CanBeDislodged()
    return (self.canbedislodgedfn == nil or self.canbedislodgedfn(self.inst)) and self.canbedislodged
end

function Dislodgeable:SetDislodged()
    self.canbedislodged = false
    self.hasbeendislodged = true
end

function Dislodgeable:Dislodge(dislodger)
    if self:CanBeDislodged(self.inst) and self.caninteractwith then
        local pt = self:GetLootDropPosition()
        local alwaysinfront = pt == nil

        for i=1,self.numtoharvest do
            local loot = self.inst.components.lootdropper:DropLootPrefab(SpawnPrefab(self.product), pt, nil, nil, alwaysinfront)

            if loot then
                if self.ondislodgedfn then
                    self.ondislodgedfn(self.inst, dislodger, loot)
                end
               
                self:SetDislodged()

                self.inst:PushEvent("dislodged", {dislodger = dislodger, loot = loot})
            end
        end
    end
end

return Dislodgeable
