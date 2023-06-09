require "behaviours/wander"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/runaway"


local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 8
local WANDER_DIST = 8
local WANDER_DIST_NIGHT = 5
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 10

local BabyOxBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function BabyOxBrain:OnStart()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        RunAway(self.inst, "character", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
        Follow(self.inst, function() return self.inst.components.follower and self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        WhileNode(
            function() 
                local tile = self.inst.components.tiletracker.tile
                if tile == GROUND.OCEAN_DEEP or tile == GROUND.OCEAN_MEDIUM then
                    local splash = SpawnPrefab("splash_water")
                    local ent_pos = Vector3(self.inst.Transform:GetWorldPosition())
                    splash.Transform:SetPosition(ent_pos.x, ent_pos.y, ent_pos.z)
                    self.inst:Remove()
                end      
                return tile == GROUND.OCEAN_MEDIUM or tile == GROUND.OCEAN_DEEP or tile == GROUND.OCEAN_SHALLOW
            end, "intheocean",  
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, WANDER_DIST_NIGHT)
        ),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, WANDER_DIST)
    }, .25)
    
    self.bt = BT(self.inst, root)
    
end

return BabyOxBrain