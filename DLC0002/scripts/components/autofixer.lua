local Autofixer = Class(function(self, inst)
    self.inst = inst

    self.onturnon = nil
    self.onturnoff = nil

    self.startFixingFn = nil
    self.stopFixingFn = nil

    self.shouldfixfn = nil

    self.shouldkeeptargetfn = nil
    self.onkeeptargetfn = nil

    self.on = false
    self.locked = false

    self.target_tags = {}
    self.range = TUNING.AUTOFIXER_RANGE

    self.inst:StartUpdatingComponent(self)
end)

function Autofixer:OnRemoveEntity()
    self.inst:StopUpdatingComponent(self)
    self:TurnOff()
end

Autofixer.OnRemoveFromEntity = Autofixer.OnRemoveEntity

function Autofixer:OnEntitySleep()
    if not self:IsOn() then
        self.inst:StopUpdatingComponent(self)
    end
end

function Autofixer:OnEntityWake()
    if not self:IsOn() then
        self.inst:StartUpdatingComponent(self)
    end
end

function Autofixer:GetDebugString()
    return string.format("  %s  |  Boat: %s  |  Boat Health: %d/%d", self.on and "ON" or "OFF", tostring(self.target or "<None>"), self.target and self.target.components.boathealth.currenthealth or 0, self.target and self.target.components.boathealth.maxhealth or 0)
end

function Autofixer:OnSave()
    return {locked = self.locked}
end

function Autofixer:OnLoad(data)
    if data then
        self.locked = data.locked
    end
end

function Autofixer:SetOnTurnOnOffFns(onfn, offfn)
    self.onturnon = onfn
    self.onturnoff = offfn
end

function Autofixer:SetStartStopFixingFns(startfn, stopfn)
    self.startFixingFn = startfn
    self.stopFixingFn = stopfn
end

function Autofixer:SetShouldFixTargetFn(shouldfixfn) -- Required
    self.shouldfixfn = shouldfixfn
end

function Autofixer:SetKeepTargetFns(shouldkeepfn, onkeepfn)
    self.shouldkeeptargetfn = shouldkeepfn
    self.onkeeptargetfn = onkeepfn
end

function Autofixer:SetTags(tagstable)
    self.target_tags = tagstable
end

function Autofixer:SetRange(range)
    self.range = range
end

function Autofixer:SetLocked(locked)
    if locked == nil then locked = true end

    self.locked = locked
end

function Autofixer:TurnOn(target)
    if not self.locked and not self.on and (not self.inst.components.fueled or not self.inst.components.fueled:IsEmpty()) then
        if target then
            if self.startFixingFn then
                self.startFixingFn(self.inst, target)
            end

            target:AddTag("autofixing")

            self.on = true
            self.target = target

            if self.onturnon then
                self.onturnon(self.inst)
            end
        end
    end
end

function Autofixer:TurnOff()
    if self.on then
        if self.stopFixingFn then
            self.stopFixingFn(self.inst, self.target)
        end

        self.target:RemoveTag("autofixing")

        self.on = false
        self.target = nil

        if self.onturnoff then
            self.onturnoff(self.inst)
        end
    end
end

function Autofixer:IsTargetInRange()
    return self.inst:IsNear(self.target, self.range) 
end

function Autofixer:OnUpdate(dt)
    if self.target and self.target:IsValid() and self:IsTargetInRange() and (not self.shouldkeeptargetfn or self.shouldkeeptargetfn(self.target)) then
        if self.onkeeptargetfn then
            self.onkeeptargetfn(self.target)
        end

        return
    end
    
    if self.target then
        self:TurnOff()
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, self.range, self.target_tags, {"autofixing"})

    for _, target in pairs(ents) do
        if target:IsValid() and not target:HasTag("autofixing") and self.shouldfixfn(target, self.inst) then
            self:TurnOn(target)
            break -- One target at time.
        end
    end
end

function Autofixer:IsOn()
    return self.on
end

return Autofixer