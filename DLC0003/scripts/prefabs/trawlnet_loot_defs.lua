
local chance_verylow  = 1
local chance_low      = 2
local chance_medium   = 4
local chance_high     = 8

-- Normal loot;
local LOOT = {
    shallow = {
        { "roe", chance_medium },
        { "seaweed", chance_high },
        { "mussel", chance_medium },
        { "lobster", chance_low },
        { "jellyfish", chance_low },
        { "fish", chance_medium },
        { "coral", chance_medium },
        { "messagebottleempty", chance_medium },
        { "fish_med", chance_low },
        { "rocks", chance_high },
    },

    medium = {
        { "roe", chance_medium },
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_low },
        { "jellyfish", chance_medium },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_medium },
        { "messagebottleempty", chance_medium },
        { "boneshard", chance_medium },
        { "spoiled_fish", chance_medium },
        { "dubloon", chance_low },
        { "goldnugget", chance_low },
        { "telescope", chance_verylow },
        { "firestaff", chance_verylow },
        { "icestaff", chance_verylow },
        { "panflute", chance_verylow },
        { "trinket_16", chance_low },
        { "trinket_17", chance_medium },
        { "trinket_18", chance_verylow },
    },

    deep = {
        { "roe", chance_low },
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_low },
        { "jellyfish", chance_high },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_high },
        { "messagebottleempty", chance_medium },
        { "boneshard", chance_medium },
        { "spoiled_fish", chance_medium },
        { "dubloon", chance_medium },
        { "goldnugget", chance_medium },
        { "telescope", chance_low },
        { "firestaff", chance_low },
        { "icestaff", chance_low },
        { "panflute", chance_low },
        { "redgem", chance_low },
        { "bluegem", chance_low },
        { "purplegem", chance_low },
        { "goldenshovel", chance_low },
        { "goldenaxe", chance_low },
        { "razor", chance_low },
        { "spear", chance_low },
        { "compass", chance_low },
        { "amulet", chance_verylow },
        { "trinket_16", chance_low },
        { "trinket_17", chance_low },
        { "trinket_18", chance_verylow },
        { "trident", chance_verylow },
    }
}

local HURRICANE_LOOT = {
    shallow = {
        { "roe", chance_medium },
        { "seaweed", chance_high },
        { "mussel", chance_medium },
        { "lobster", chance_medium },
        { "jellyfish", chance_medium },
        { "fish", chance_high },
        { "coral", chance_high },
        { "messagebottleempty", chance_high },
        { "fish_med", chance_medium },
        { "rocks", chance_high },
        { "dubloon", chance_low },
        { "trinket_16", chance_low },
        { "trinket_17", chance_low },
    },

    medium = {
        { "roe", chance_medium },
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_medium },
        { "jellyfish", chance_high },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_high },
        { "messagebottleempty", chance_high },
        { "boneshard", chance_high },
        { "spoiled_fish", chance_high },
        { "dubloon", chance_medium },
        { "goldnugget", chance_medium },
        { "telescope", chance_low },
        { "firestaff", chance_low },
        { "icestaff", chance_low },
        { "panflute", chance_low },
        { "trinket_16", chance_low },
        { "trinket_17", chance_low },
        { "trinket_18", chance_verylow },
        { "trident", chance_verylow },
    },

    deep = {
        { "roe", chance_low },
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_low },
        { "jellyfish", chance_high },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_high },
        { "messagebottleempty", chance_high },
        { "boneshard", chance_high },
        { "spoiled_fish", chance_high },
        { "dubloon", chance_medium },
        { "goldnugget", chance_medium },
        { "telescope", chance_medium },
        { "firestaff", chance_low },
        { "icestaff", chance_medium },
        { "panflute", chance_medium },
        { "redgem", chance_medium },
        { "bluegem", chance_medium },
        { "purplegem", chance_medium },
        { "goldenshovel", chance_medium },
        { "goldenaxe", chance_medium },
        { "razor", chance_medium },
        { "spear", chance_medium },
        { "compass", chance_medium },
        { "amulet", chance_verylow },
        { "trinket_16", chance_medium },
        { "trinket_17", chance_medium },
        { "trinket_18", chance_verylow },
        { "trident", chance_low },
    }
}

local DRY_LOOT = {
    shallow = {
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_medium },
        { "jellyfish", chance_medium },
        { "fish", chance_high },
        { "coral", chance_high },
        { "messagebottleempty", chance_high },
        { "fish_med", chance_medium },
        { "rocks", chance_high },
        { "dubloon", chance_low },
        { "obsidian", chance_high },
    },

    medium = {
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_medium },
        { "jellyfish", chance_high },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_high },
        { "messagebottleempty", chance_high },
        { "boneshard", chance_high },
        { "spoiled_fish", chance_high },
        { "dubloon", chance_medium },
        { "goldnugget", chance_medium },
        { "telescope", chance_low },
        { "firestaff", chance_medium },
        { "icestaff", chance_low },
        { "panflute", chance_low },
        { "obsidian", chance_medium },
        { "trinket_16", chance_low },
        { "trinket_17", chance_low },
        { "trinket_18", chance_verylow },
        { "trident", chance_verylow },
    },

    deep = {
        { "seaweed", chance_high },
        { "mussel", chance_high },
        { "lobster", chance_low },
        { "jellyfish", chance_high },
        { "fish", chance_high },
        { "coral", chance_high },
        { "fish_med", chance_high },
        { "messagebottleempty", chance_high },
        { "boneshard", chance_high },
        { "spoiled_fish", chance_high },
        { "dubloon", chance_medium },
        { "goldnugget", chance_medium },
        { "telescope", chance_medium },
        { "firestaff", chance_medium },
        { "icestaff", chance_low },
        { "panflute", chance_medium },
        { "redgem", chance_medium },
        { "bluegem", chance_medium },
        { "purplegem", chance_medium },
        { "goldenshovel", chance_medium },
        { "goldenaxe", chance_medium },
        { "razor", chance_medium },
        { "spear", chance_medium },
        { "compass", chance_medium },
        { "amulet", chance_verylow },
        { "obsidian", chance_medium },
        { "trinket_16", chance_low },
        { "trinket_17", chance_low },
        { "trinket_18", chance_verylow },
        { "trident", chance_low },
    }
}

-- Porkland loot;
local LILYPOND_LOOT = {
    shallow = {
        { "cutreeds", chance_high },
        { "cutgrass", chance_high },
        { "twigs", chance_high },
        { "rocks", chance_high },
        { "log", chance_high },
        { "fish", chance_high },
        { "lotus_flower", chance_medium },
        { "rottenegg", chance_medium },
        { "oinc", chance_medium },
        { "iron", chance_medium },
        { "spoiled_fish", chance_medium },
        { "bill_quill", chance_medium },
        { "boneshard", chance_medium },
        { "goldnugget", chance_low },
        { "fabric", chance_low },
        { "goldenshovel", chance_low },
        { "goldenaxe", chance_low },
        { "disarming_kit", chance_low },
        { "shears", chance_low },
        { "trinket_17", chance_low },
        { "oinc10", chance_low },
        { "redgem", chance_verylow },
        { "bluegem", chance_verylow },
        { "purplegem", chance_verylow },
        { "amulet", chance_verylow },
        { "relic_1", chance_verylow },
        { "relic_2", chance_verylow },
        { "relic_3", chance_verylow },
        { "trinket_giftshop_1", chance_verylow },
        { "trinket_giftshop_3", chance_verylow },
        { "trinket_18", chance_verylow },
    },
    medium = {},
    deep = {},
}

-- Don't collect more than one of these.
local UNIQUE_ITEMS = {
    "trinket_16",
    "trinket_17",
    "trinket_18",
    "trident",
    "relic_1",
    "relic_2",
    "relic_3",
    "trinket_giftshop_1",
    "trinket_giftshop_3",
}

local SPECIAL_CASE_PREFABS = {
    seaweed_planted = function(inst, net)
        if inst and inst.components.pickable then
            if inst.components.pickable.canbepicked
                and inst.components.pickable.caninteractwith then
                net:pickupitem(SpawnPrefab(inst.components.pickable.product))
            end

            inst:Remove()
            return SpawnPrefab("seaweed_stalk")
        end
    end,

    jellyfish_planted = function(inst)
        inst:Remove()
        return SpawnPrefab("jellyfish")
    end,

    mussel_farm = function(inst, net)
        if inst then
            if inst.growthstage <= 0 then
                inst:Remove()
                return SpawnPrefab(inst.components.pickable.product)
            end
        end
    end,

    sunkenprefab = function(inst)
        local sunken = SpawnSaveRecord(inst.components.sunkenprefabinfo:GetSunkenPrefab())
        sunken:LongUpdate(inst.components.sunkenprefabinfo:GetTimeSubmerged())

        inst:Remove()
        return sunken
    end,

    lobster = function(inst)
        return inst
    end,
}

return {
    LOOT                 = LOOT,
    HURRICANE_LOOT       = HURRICANE_LOOT,
    DRY_LOOT             = DRY_LOOT,
    LILYPOND_LOOT        = LILYPOND_LOOT,
    UNIQUE_ITEMS         = UNIQUE_ITEMS,
    SPECIAL_CASE_PREFABS = SPECIAL_CASE_PREFABS,
}
