local Dislodger = Class(function(self, inst)
    self.inst = inst
   	self.inst:AddTag("dislodger") 
end)

function Dislodger:OnRemoveFromEntity()
    self.inst:RemoveTag("dislodger") 
end

function Dislodger:CollectEquippedActions(doer, target, actions)
    if target.components.dislodgeable and target.components.dislodgeable:CanBeDislodged() then
        table.insert(actions, ACTIONS.DISLODGE)
    end
end

return Dislodger
