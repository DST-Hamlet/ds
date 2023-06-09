local function OnNewCombatTarget(inst, data)
    inst.components.leader:OnNewTarget(data.target)
end

local function OnAttacked(inst, data)
    inst.components.leader:OnAttacked(data.attacker)
end

local function OnDeath(inst)
    inst.components.leader:RemoveAllFollowers()
end

local Leader = Class(function(self, inst)
    self.inst = inst
    self.followers = {}
    self.numfollowers = 0

	--self.loyaltyeffectiveness = nil

    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDeath)

    self._onfollowerdied = function(follower)    self:RemoveFollower(follower)       end
    self._onfollowerremoved = function(follower) self:RemoveFollower(follower, true) end
end)

function Leader:IsFollower(guy)
    return self.followers[guy] ~= nil
end

function Leader:OnAttacked(attacker)
    if not self:IsFollower(attacker) and self.inst ~= attacker then
        for k,v in pairs(self.followers) do
            if k.components.combat and k.components.follower and k.components.follower.canaccepttarget then
                k.components.combat:SuggestTarget(attacker)
            end
        end
    end
end

function Leader:CountFollowers(tag)
    if not tag then
        return self.numfollowers
    else
        local count = 0
        for k,v in pairs(self.followers) do
            if k:HasTag(tag) then
                count = count + 1
            end
        end
        return count
    end
end

function Leader:OnNewTarget(target)
    for k,v in pairs(self.followers) do
        if k.components.combat and k.components.follower and k.components.follower.canaccepttarget then
            k.components.combat:SuggestTarget(target)
        end
    end
end

function Leader:RemoveFollower(follower, invalid)
    if follower and self.followers[follower] then
        self.followers[follower] = nil
        self.numfollowers = self.numfollowers - 1

        self.inst:RemoveEventCallback("death", self._onfollowerdied, follower)
        self.inst:RemoveEventCallback("onremove", self._onfollowerremoved, follower)

        if self.onremovefollower then
            self.onremovefollower(self.inst, follower)
        end

        if not invalid then
            follower:PushEvent("stopfollowing", { leader = self.inst })
	        follower.components.follower:SetLeader(nil)
		end
    end
end

function Leader:AddFollower(follower)
    if self.followers[follower] == nil and follower.components.follower then
        self.followers[follower] = true
        self.numfollowers = self.numfollowers + 1
        follower.components.follower:SetLeader(self.inst)
        follower:PushEvent("startfollowing", {leader = self.inst} )
       
        self.inst:ListenForEvent("death", self._onfollowerdied, follower)
        self.inst:ListenForEvent("onremove", self._onfollowerremoved, follower)

	    if self.inst:HasTag( "player" ) and follower.prefab then
		    ProfileStatsAdd("befriend_"..follower.prefab)
	    end
	end
end

function Leader:RemoveFollowersByTag(tag, validateremovefn)
    for k,v in pairs(self.followers) do
        if k:HasTag(tag) then
            if validateremovefn then
                if validateremovefn(k) then
                    self:RemoveFollower(k)
                end
            else
                self:RemoveFollower(k)
            end
        end
    end
end


function Leader:RemoveAllFollowers()
    --print("Leader:RemoveAllFollowers")
    for k,v in pairs(self.followers) do
        self:RemoveFollower(k)
    end
end

function Leader:IsBeingFollowedBy(prefabName)
    for k,v in pairs(self.followers) do
        if k.prefab == prefabName then
            return true
        end
    end
    return false
end


function Leader:OnSave()
    
    local saved = false
    local followers = {}
    for k,v in pairs(self.followers) do
        saved = true
        table.insert(followers, k.GUID)
    end
    
    if saved then
        return {followers = followers}, followers
    end
    
end

function Leader:LoadPostPass(newents, savedata)
    if savedata and savedata.followers then
        for k,v in pairs(savedata.followers) do
            local targ = newents[v]
            if targ and targ.entity.components.follower then
                self:AddFollower(targ.entity)
            end
        end
    end
end

function Leader:OnRemoveEntity()
	self:RemoveAllFollowers()
end

function Leader:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("newcombattarget", OnNewCombatTarget)
    self.inst:RemoveEventCallback("attacked", OnAttacked)
    self.inst:RemoveEventCallback("death", OnDeath)
    self:RemoveAllFollowers()
end

return Leader
