local FX =
{
    {
	    name = "sanity_raise", 
	    bank = "blocker_sanity_fx", 
	    build = "blocker_sanity_fx", 
	    anim = "raise",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = 0.5,
    },

    {
	    name = "sanity_lower", 
	    bank = "blocker_sanity_fx", 
	    build = "blocker_sanity_fx", 
	    anim = "lower",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = 0.5,
    },

    {
	    name = "die_fx", 
	    bank = "die_fx", 
	    build = "die", 
	    anim = "small",
	    sound = "dontstarve/common/deathpoof",
	    sounddelay = nil,
	    tint = Vector3(90/255, 66/255, 41/255),
	    tintalpha = nil,
    },

    {
	    name = "sparks_fx", 
	    bank = "sparks", 
	    build = "sparks", 
	    anim = {"sparks_1", "sparks_2", "sparks_3"},
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },
    {
	    name = "firework_fx", 
	    bank = "firework", 
	    build = "accomplishment_fireworks", 
	    anim = "single_firework",
	    sound = "dontstarve/common/shrine/sadwork_fire",
	    sound2 = "dontstarve/common/shrine/sadwork_explo",
	    sounddelay2 = 26/30,
	    tint = nil,
	    tintalpha = nil,
	    fnc = function() GetClock():DoLightningLighting(.25) end,
	    fntime = 26/30
    },    
    {
	    name = "multifirework_fx", 
	    bank = "firework", 
	    build = "accomplishment_fireworks", 
	    anim = "multi_firework",
	    sound = "dontstarve/common/shrine/sadwork_fire",
	    sound2 = "dontstarve/common/shrine/firework_explo",
	    sounddelay2 = 26/30,
	    tint = nil,
	    tintalpha = nil,
	    fnc = function() GetClock():DoLightningLighting(1) end,
	    fntime = 26/30
    },    

    {
	    name = "explode_small", 
	    bank = "explode", 
	    build = "explode", 
	    anim = "small",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },

    {
	    name = "lightning_rod_fx", 
	    bank = "lightning_rod_fx", 
	    build = "lightning_rod_fx", 
	    anim = "idle",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },


    {
	    name = "splash", 
	    bank = "splash", 
	    build = "splash", 
	    anim = "splash",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },

    {
	    name = "small_puff", 
	    bank = "small_puff", 
	    build = "smoke_puff_small", 
	    anim = "puff",
	    sound = "dontstarve/common/deathpoof",
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },

    {
	    name = "splash_ocean", 
	    bank = "splash", 
	    build = "splash_ocean", 
	    anim = "idle",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },

    {
	    name = "maxwell_smoke", 
	    bank = "max_fx", 
	    build = "max_fx", 
	    anim = "anim",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },
    {
	    name = "shovel_dirt", 
	    bank = "shovel_dirt", 
	    build = "shovel_dirt", 
	    anim = "anim",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },    
    {
	    name = "mining_fx", 
	    bank = "mining_fx", 
	    build = "mining_fx", 
	    anim = "anim",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },    
    {
	    name = "pine_needles", 
	    bank = "pine_needles", 
	    build = "pine_needles", 
	    anim = {"chop", "fall"},
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = nil,
    },

    {
	    name = "dr_warm_loop_1", 
	    bank = "diviningrod_fx", 
	    build = "diviningrod_fx", 
	    anim = "warm_loop",
	    sound = nil,
	    sounddelay = nil,
	    tint = Vector3(105/255, 160/255, 255/255),
	    tintalpha = nil,
    },

    {
	    name = "dr_warm_loop_2", 
	    bank = "diviningrod_fx", 
	    build = "diviningrod_fx", 
	    anim = "warm_loop",
	    sound = nil,
	    sounddelay = nil,
	    tint = Vector3(105/255, 182/255, 239/255),
	    tintalpha = nil,
    },

    {
	    name = "dr_warmer_loop", 
	    bank = "diviningrod_fx", 
	    build = "diviningrod_fx", 
	    anim = "warmer_loop",
	    sound = nil,
	    sounddelay = nil,
	    tint = Vector3(255/255, 163/255, 26/255),
	    tintalpha = nil,
    },

    {
	    name = "dr_hot_loop", 
	    bank = "diviningrod_fx", 
	    build = "diviningrod_fx", 
	    anim = "hot_loop",
	    sound = nil,
	    sounddelay = nil,
	    tint = Vector3(181/255, 32/255, 32/255),
	    tintalpha = nil,
    },

    {
	    name = "statue_transition", 
	    bank = "statue_ruins_fx", 
	    build = "statue_ruins_fx", 
	    anim = "transform_nightmare",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = 0.6,
    },

    {
	    name = "statue_transition_2", 
	    bank = "die_fx", 
	    build = "die", 
	    anim = "small",
	    sound = "dontstarve/common/deathpoof",
	    sounddelay = nil,
	    tint = Vector3(0,0,0),
	    tintalpha = 0.6,
    },

    {
	    name = "sparklefx", 
	    bank = "sparklefx", 
	    build = "sparklefx", 
	    anim = "sparkle",
	    sounddelay = nil,
	    tint = nil,
	    --transform = Vector3(1.5, 1, 1)
    },
    {
	    name = "book_fx", 
	    bank = "book_fx", 
	    build = "book_fx", 
	    anim = "book_fx",
	    sound = nil,
	    sounddelay = nil,
	    tint = nil,
	    tintalpha = 0.4,
	    --transform = Vector3(1.5, 1, 1)
    },
    {
	    name = "waxwell_book_fx", 
	    bank = "book_fx", 
	    build = "book_fx", 
	    anim = "book_fx",
	    sound = nil,
	    sounddelay = nil,
	    tint =  Vector3(0,0,0),
	    tintalpha = nil,
	    --transform = Vector3(1.5, 1, 1)
    },

    {
	    name = "chester_transform_fx", 
	    bank = "die_fx", 
	    build = "die", 
	    anim = "small",
    },
    {
        name = "spat_splat_fx",
        bank = "spat_splat",
        build = "spat_splat",
        anim = "idle",
    },	
    {
        name = "spat_splash_fx_full",
        bank = "spat_splash",
        build = "spat_splash",
        anim = "full",     
    },
    {
        name = "spat_splash_fx_med",
        bank = "spat_splash",
        build = "spat_splash",
        anim = "med",     
    },
    {
        name = "spat_splash_fx_low",
        bank = "spat_splash",
        build = "spat_splash",
        anim = "low",      
    },
    {
        name = "spat_splash_fx_melted", 
        bank = "spat_splash", 
        build = "spat_splash", 
        anim = "melted",      
    },
    {
        name = "beefalo_transform_fx",
        bank = "beefalo_fx",
        build = "beefalo_fx",
        anim = "transform",
        --#TODO: this one
        sound = "dontstarve/ghost/ghost_haunt",
    },
    {
	    name = "groundpound_fx", 
	    bank = "bearger_ground_fx", 
	    build = "bearger_ground_fx", 
	    --sound = "dontstarve_DLC001/creatures/bearger/dustpoof",
    	anim = "idle",	  
    },    
	{
        name = "bundle_unwrap",
        bank = "bundle",
        build = "bundle",
        anim = "unwrap",
    },
	{
        name = "sand_puff_large_front",
        bank = "sand_puff",
        build = "sand_puff",
        anim = "forage_out",
        sound = "dontstarve/common/deathpoof",
        transform = Vector3(1.5, 1.5, 1.5),
        fn = function(inst)
            inst.AnimState:SetFinalOffset(2)
            inst.AnimState:Hide("back")
        end,
    },
    {
        name = "sand_puff_large_back",
        bank = "sand_puff",
        build = "sand_puff",
        anim = "forage_out",
        transform = Vector3(1.5, 1.5, 1.5),
        fn = function(inst)
            inst.AnimState:Hide("front")
        end,
    },
    {
        name = "sand_puff",
        bank = "sand_puff",
        build = "sand_puff",
        anim = "forage_out",
        sound = "dontstarve/common/deathpoof",
    },
	{
        name = "minotaur_blood1",
        bank = "rook_rhino_blood_fx",
        build = "rook_rhino_blood_fx",
        anim = "blood1",
        sound = "ancientguardian_rework/minotaur2/blood_splurt_small",
        nofaced = true,
        fn = function(inst)
            inst.AnimState:SetMultColour(1, 1, 1, .5)
            inst.Transform:SetTwoFaced()
        end,
    },
    {
        name = "minotaur_blood2",
        bank = "rook_rhino_blood_fx",
        build = "rook_rhino_blood_fx",
        anim = "blood2",
        sound = "ancientguardian_rework/minotaur2/blood_splurt_small",
        nofaced = true,
        fn = function(inst)
            inst.AnimState:SetMultColour(1, 1, 1, .5)
            inst.Transform:SetTwoFaced()
        end,
    },
    {
        name = "minotaur_blood3",
        bank = "rook_rhino_blood_fx",
        build = "rook_rhino_blood_fx",
        anim = "blood3",
        sound = "ancientguardian_rework/minotaur2/blood_splurt_small",
        nofaced = true,
        fn = function(inst)
            inst.AnimState:SetMultColour(1, 1, 1, .5)
            inst.Transform:SetTwoFaced()
        end,
    },
}

return FX