local function onattacked(inst,data )
	
	if inst.components.follower.leader == data.attacker then
		inst.components.follower:SetLeader(nil)
	end

end

local Follower = Class(function(self, inst)
    self.inst = inst
    self.leader = nil
	self.previousleader = nil
	self.hibernatedleader = nil
    self.targettime = nil
    self.maxfollowtime = nil
    self.canaccepttarget = true
    self.exit_destinations = { EXIT_DESTINATION.LAND }

    self.inst:ListenForEvent("attacked", onattacked)

	self.OnLeaderRemoved = function()
        self:SetLeader(nil)
    end
end)

--[[
local willStopFollowing = {}
local function FollowerUpdate(dt)
	local tick = TheSim:GetTick()
	if willStopFollowing[tick] then
		for k,v in pairs(willStopFollowing[tick]) do
			if v:IsValid() and v.components.follower then
			    v:PushEvent("loseloyalty", {leader=v.components.follower.leader})
				v.components.follower:SetLeader(nil)
				v.components.follower.targettime = nil
				v.components.follower.targettick = nil
			end
		end
		willStopFollowing[tick] = nil
	end	
end
--]]

function Follower:GetDebugString()
    local str = "Following "..tostring(self.leader)
	if self.targettime then
		str = str..string.format(" Stop in %2.2fs, %2.2f%%", self.targettime - GetTime(), 100*self:GetLoyaltyPercent())
	end
	return str
end

function Follower:StartLeashing()
    self.inst.portnearleader = function()
    	if not self.leader or (self.leader and (self.leader:IsAsleep() and not self.leader:HasTag("follower_leash"))) then
    		return
    	end

	    local exit_destination = EXIT_DESTINATION.LAND
	    if self.leader:GetIsOnWater() then
			exit_destination = EXIT_DESTINATION.WATER
	    end

    	if self:CanFollowLeaderThroughExit(exit_destination) then 
	    	local init_pos = self.inst:GetPosition()
	    	local leader_pos = self.leader:GetPosition()
	    	local angle = self.leader:GetAngleToPoint(init_pos)
	    	local offset = FindWalkableOffset(leader_pos, angle*DEGREES, 30, 10) or Vector3(0,0,0)

	    	if distsq(leader_pos, init_pos) > 1600 then
				local pos = leader_pos + offset
	    		--There's a crash if you teleport without the delay
	    		if self.inst.components.combat then
	    			self.inst.components.combat:SetTarget(nil)
	    		end
	    		self.inst:DoTaskInTime(.1, function() 
		    		self.inst.Transform:SetPosition(pos:Get())
	    		end)
	    	end
    	end
	end

    self.inst:ListenForEvent("entitysleep", self.inst.portnearleader)    
end

function Follower:StopLeashing()
	if self.inst.portnearleader then -- If this function exists then the follower also has the callback. 
		self.inst:RemoveEventCallback("entitysleep", self.inst.portnearleader)
	end
end

function Follower:HibernateLeader(hibernate)
	if hibernate == false then

		self.leader = self.hibernatedleader
		self.hibernatedleader = nil
		
		if self.leader and (self.leader:HasTag("player") or self.leader:HasTag("follower_leash")) then 
			self:StartLeashing()
		end
	elseif self.hibernatedleader ~= nil then
		print("!!ERROR: Leader Already Hibernated")
	elseif hibernate then
		self.hibernatedleader = self.leader
		self.leader = nil
		self:StopLeashing()
	end
end

function Follower:SetLeader(inst)
	self.previousleader = self.leader
    if self.leader and self.leader.components.leader then
        self.leader.components.leader:RemoveFollower(self.inst)
		self.inst:RemoveEventCallback("onremove", self.OnLeaderRemoved, self.previousleader)
    end
    if inst and inst.components.leader then
        inst.components.leader:AddFollower(self.inst)
    end
    self.leader = inst

	if self.leader then
		self.inst:ListenForEvent("onremove", self.OnLeaderRemoved, self.leader)
	end
    
    if self.leader and (self.leader:HasTag("player") or self.leader:HasTag("follower_leash")) then 
		self:StartLeashing()
	end

    if inst == nil then
		if self.task then
			self.task:Cancel()
			self.task = nil
			self:StopLeashing()
		end
    end
end


function Follower:SetFollowExitDestinations(exit_list)
	self.exit_destinations = exit_list
end

function Follower:CanFollowLeaderThroughExit(exit_destination)
	local canFollow = false
	for k,v in ipairs(self.exit_destinations) do
		if v == exit_destination then
			canFollow = true
		end
	end
	return canFollow
end

function Follower:GetLoyaltyPercent()
    if self.targettime and self.maxfollowtime then
        local timeLeft = math.max(0, self.targettime - GetTime())
        return timeLeft / self.maxfollowtime
    end
    return 0
end


local function stopfollow(inst)
	if inst:IsValid() and inst.components.follower then
		inst:PushEvent("loseloyalty", {leader=inst.components.follower.leader})
		inst.components.follower:SetLeader(nil)
	end
end

function Follower:AddLoyaltyTime(time)
    
    local currentTime = GetTime()
    local timeLeft = self.targettime or 0
    timeLeft = math.max(0, timeLeft - currentTime)
    timeLeft = math.min(self.maxfollowtime or 0, timeLeft + time)
    
    self.targettime = currentTime + timeLeft

	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	self.task = self.inst:DoTaskInTime(timeLeft, stopfollow)
end

function Follower:StopFollowing()
	if self.inst:IsValid() then
		self.inst:PushEvent("loseloyalty", {leader=self.inst.components.follower.leader})
		self.inst.components.follower:SetLeader(nil)
		self:StopLeashing()
	end
end

function Follower:IsNearLeader(dist)
    return self.leader and self.inst:IsNear(self.leader, dist)
end

function Follower:OnSave()
    local time = GetTime()
    if self.targettime and self.targettime > time then
        return {time = math.floor(self.targettime - time) }
    end
end

function Follower:OnLoad(data)
    if data.time then
        self:AddLoyaltyTime(data.time)
    end
end

function Follower:LongUpdate(dt)
	if self.leader and self.task and self.targettime then
		
		self.task:Cancel()
		self.task = nil
		
		local time = GetTime()
		local time_left = self.targettime - GetTime() - dt
		if time_left < 0 then
			self:SetLeader(nil)	
		else
			self.targettime = GetTime() + time_left
			self.task = self.inst:DoTaskInTime(time_left, stopfollow)
		end
	end
end

--RegisterStaticComponentUpdate("follower", FollowerUpdate)

return Follower