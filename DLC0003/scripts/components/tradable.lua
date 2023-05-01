local Tradable = Class(function(self, inst)
    self.inst = inst
    self.goldvalue = 0
end)

-- Can only trade with inventory items, if mounted.
function Tradable:CollectUseActions(doer, target, actions)
	if 	(target.components.trader and target.components.trader.enabled) or
		(target.components.weapon and target.components.trader and target.components.trader:CanAccept(self.inst, doer))
	then
		if not (
			doer.components.rider ~= nil and doer.components.rider:IsRiding() and
			not (target.components.inventoryitem ~= nil and target.components.inventoryitem:IsGrandOwner(doer))
		)
		then
			table.insert(actions, ACTIONS.GIVE)
		end
	end
end

return Tradable