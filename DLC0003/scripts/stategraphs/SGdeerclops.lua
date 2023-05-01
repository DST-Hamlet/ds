require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.HAMMER, "attack"),
	ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40

local function DeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
    if player then
        player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.5, 0.03, 2, SHAKE_DIST)
    end
end

local AREAATTACK_MUST_TAGS = { "hascombatcomponent" }
local AREA_EXCLUDE_TAGS = { "INLIMBO", "notarget", "noattack", "invisible"}
local ICESPAWNTIME =  0.25
    
local function DoSpawnIceSpike(inst, x, z)
    SpawnPrefab("icespike_fx_"..tostring(math.random(1, 4))).Transform:SetPosition(x, 0, z)

    local ents = TheSim:FindEntities(x, 0, z, 1.5, AREAATTACK_MUST_TAGS, AREA_EXCLUDE_TAGS)
    if #ents > 0 then
        for i,ent in ipairs(ents)do
            if ent ~= inst then
                if not inst._icespikeshit_targets[ent.GUID] and inst.components.combat:CanTarget(ent) and not ent.deerclopsattacked then
					inst.components.combat:DoAttack(ent)
					inst._icespikeshit = true
	                inst._icespikeshit_targets[ent.GUID] = true
                end
                ent.deerclopsattacked = true
                ent:DoTaskInTime(ICESPAWNTIME +0.03,function() ent.deerclopsattacked = nil end)
            end
        end
    end
end

local function CheckForIceSpikesMiss(inst)
	if inst._icespikeshit_task ~= nil then
		inst._icespikeshit_task:Cancel()
		inst._icespikeshit_task = nil
	end

	if not inst._icespikeshit then
        inst:PushEvent("onmissother", {}) -- for ChaseAndAttack
	end
end

local function SpawnIceFx(inst, target)
	inst._icespikeshit_targets = {}

	local AOEarc = 35

    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = inst.Transform:GetRotation()

    local num = 3
    for i=1,num do
        local newarc = 180 - AOEarc
        local theta =  inst.Transform:GetRotation()*DEGREES
        local radius = TUNING.DEERCLOPS_ATTACK_RANGE - ( (TUNING.DEERCLOPS_ATTACK_RANGE/num)*i )
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        inst:DoTaskInTime(math.random() * .25, DoSpawnIceSpike, x+offset.x, z+offset.z)
    end

    for i=math.random(12,17),1,-1 do
        local theta =  ( angle + math.random(AOEarc *2) - AOEarc ) * DEGREES
        local radius = TUNING.DEERCLOPS_ATTACK_RANGE * math.sqrt(math.random())
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        inst:DoTaskInTime(math.random() * ICESPAWNTIME, DoSpawnIceSpike, x+offset.x, z+offset.z)
    end

    for i=math.random(5,8),1,-1 do
        local newarc = 180 - AOEarc
        local theta =  ( angle -180 + math.random(newarc *2) - newarc ) * DEGREES
        local radius = 2 * math.random() +1
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        inst:DoTaskInTime(math.random() * ICESPAWNTIME, DoSpawnIceSpike, x+offset.x, z+offset.z)
    end 

	inst._icespikeshit = false
	if inst._icespikeshit_task ~= nil then
		inst._icespikeshit_task:Cancel()
	end
	inst._icespikeshit_task = inst:DoTaskInTime(ICESPAWNTIME + FRAMES, CheckForIceSpikesMiss)
end

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states=
{
    State{
        name = "gohome",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst:ClearBufferedAction()
            inst.components.knownlocations:RememberLocation("home", nil)
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },      
    
	State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
                inst:ClearBufferedAction()
                inst.components.knownlocations:RememberLocation("home", nil)
            end
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates( states,
{
	starttimeline =
	{
        TimeEvent(7*FRAMES, DeerclopsFootstep),
	},
    walktimeline = 
    { 
        TimeEvent(23*FRAMES, DeerclopsFootstep),
        TimeEvent(42*FRAMES, DeerclopsFootstep),
    },
    endtimeline=
    {
        TimeEvent(5*FRAMES, DeerclopsFootstep),
    },
})

CommonStates.AddCombatStates(states,
{
	hittimeline =
	{
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/hurt") end),
	},
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
        TimeEvent(29*FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
        TimeEvent(35*FRAMES, function(inst)            
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
            -- THE ATTACK DAMAGE COMES FROM THE DEERCLOPS SMALL ICE SPICE FX NOW.
            --inst.components.combat:DoAttack(inst.sg.statemem.target)
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.HAMMER then
                inst.bufferedaction.target.components.workable:SetWorkLeft(1)
                inst:PerformBufferedAction()
            end
            local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
            if player then
                player.components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 2, SHAKE_DIST)
            end
        end),
        TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },
    deathtimeline=
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/death") end),
        TimeEvent(50*FRAMES, function(inst)
            if GetSeasonManager():GetSnowPercent() > 0.02 then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")
            else
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
            end    
            local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
            if player then
                player.components.playercontroller:ShakeCamera(inst, "FULL", 0.7, 0.02, 3, SHAKE_DIST)
            end
        end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        --TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("deerclops", states, events, "idle", actionhandlers)

