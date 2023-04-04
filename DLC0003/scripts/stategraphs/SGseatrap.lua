local events =
{
    EventHandler("ondropped", function(inst)
        inst.sg:GoToState(inst:GetIsOnWater() and "idle" or "idle_ground")
    end),
}

local states =
{
    State{
        name = "idle_ground",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle")
        end,
    },

    State{
        name = "idle",
        onenter = function(inst)
            inst.AnimState:PlayAnimation(inst.components.trap.bait and "idle_baited" or "idle_water", true)
        end,

        events =
        {
            EventHandler("springtrap", function(inst, data)
                if data ~= nil and data.loading then
                    inst.sg:GoToState(inst.components.trap.lootprefabs ~= nil and "full" or "empty")
                elseif inst.entity:IsAwake() then
                    inst.sg:GoToState("sprung")
                else
                    inst.components.trap:DoSpring()
                    inst.sg:GoToState(inst.components.trap.lootprefabs ~= nil and "full" or "empty")
                end
            end),

            EventHandler("baited", function(inst)
                inst.AnimState:PlayAnimation("idle_baited", true)
            end),
        },
    },

    State{
        name = "full",
        onenter = function(inst, target)
            inst.AnimState:PlayAnimation("trap_loop")
        end,

        events =
        {
            EventHandler("harvesttrap", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("full") end),
        },
    },

    State{
        name = "empty",
        onenter = function(inst, target)
            inst.AnimState:PlayAnimation("side", true)
        end,

        events =
        {
            EventHandler("harvesttrap", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "sprung",
        onenter = function(inst, target)
            inst.AnimState:PlayAnimation(inst.components.trap.bait and "trap_baited_pre" or "trap_pre")

            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem.canbepickedup = false
            end
        end,

        timeline =
        {
            TimeEvent(13*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sea_trap/sea_trap_drop")
            end),
            TimeEvent(15*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sea_trap/sea_trap_ground_hit")
            end),
            TimeEvent(17*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sea_trap/sea_trap_flag")
                inst.components.trap:DoSpring()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState(inst.components.trap.lootprefabs ~= nil and "full" or "empty")
            end),
        },

        onexit = function(inst)
            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem.canbepickedup = true
            end
        end,
    },
}

return StateGraph("trap", states, events, "idle")
