require "constants"

local GROUND_PROPERTIES = {
	
	{ GROUND.MANGROVE,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_water_mangrove.tex",	runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.BEACH,		{ name = "beach",		noise_texture = "levels/textures/Ground_noise_sand.tex",			runsound="run_sand",		walksound="walk_sand",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.ROAD,		{ name = "cobblestone",		noise_texture = "images/square.tex",							runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.MARSH,		{ name = "marsh",		noise_texture = "levels/textures/Ground_noise_marsh.tex",			runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.ROCKY,		{ name = "rocky",		noise_texture = "levels/textures/noise_rocky.tex",					runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.SAVANNA,	{ name = "yellowgrass",	noise_texture = "levels/textures/Ground_noise_grass_detail.tex",	runsound="run_tallgrass",	walksound="walk_tallgrass",	snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.FOREST,	{ name = "forest",		noise_texture = "levels/textures/Ground_noise.tex",					runsound="run_woods",		walksound="walk_woods",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.GRASS,		{ name = "grass",		noise_texture = "levels/textures/Ground_noise.tex",					runsound="run_grass",		walksound="walk_grass",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.DIRT,		{ name = "dirt",		noise_texture = "levels/textures/Ground_noise_dirt.tex",			runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.DECIDUOUS,	{ name = "deciduous",	noise_texture = "levels/textures/Ground_noise_deciduous.tex",		runsound="run_carpet",		walksound="walk_carpet",	snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.DESERT_DIRT,{ name = "desert_dirt", noise_texture = "levels/textures/Ground_noise_dirt.tex",			runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_snow", mudsound = "run_mud"	} },

	{ GROUND.VOLCANO_ROCK,{ name = "rocky",		noise_texture = "levels/textures/ground_volcano_noise.tex",			runsound="run_rock",		walksound="walk_rock",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.VOLCANO,	{ name = "cave",		noise_texture = "levels/textures/ground_lava_rock.tex",				runsound="run_rock",		walksound="walk_rock",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.ASH,		{ name = "cave",		noise_texture = "levels/textures/ground_ash.tex",					runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },

	{ GROUND.JUNGLE,	{ name = "jungle",		noise_texture = "levels/textures/Ground_noise_jungle.tex",			runsound="run_woods",		walksound="walk_woods",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.SWAMP,		{ name = "swamp",		noise_texture = "levels/textures/Ground_noise_swamp.tex",			runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.MAGMAFIELD,{ name = "cave",		noise_texture = "levels/textures/Ground_noise_magmafield.tex",		runsound="run_slate",		walksound="walk_slate",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.TIDALMARSH,{ name = "tidalmarsh",	noise_texture = "levels/textures/Ground_noise_tidalmarsh.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.MEADOW,	{ name = "jungle",		noise_texture = "levels/textures/Ground_noise_savannah_detail.tex",	runsound="run_tallgrass",	walksound="walk_tallgrass",	snowsound="run_snow", mudsound = "run_mud"	} },

	{ GROUND.CAVE,		{ name = "cave",		noise_texture = "levels/textures/noise_cave.tex",					runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.FUNGUS,	{ name = "cave",		noise_texture = "levels/textures/noise_fungus.tex",					runsound="run_moss",		walksound="walk_moss",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.FUNGUSRED,	{ name = "cave",		noise_texture = "levels/textures/noise_fungus_red.tex",				runsound="run_moss",		walksound="walk_moss",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.FUNGUSGREEN,{ name = "cave",		noise_texture = "levels/textures/noise_fungus_green.tex", 			runsound="run_moss",		walksound="walk_moss",		snowsound="run_ice", mudsound = "run_mud"		} },
	
	{ GROUND.SINKHOLE,	{ name = "cave",		noise_texture = "levels/textures/noise_sinkhole.tex",				runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.UNDERROCK,	{ name = "cave",		noise_texture = "levels/textures/noise_rock.tex",					runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.MUD,		{ name = "cave",		noise_texture = "levels/textures/noise_mud.tex",					runsound="run_mud",			walksound="walk_mud",		snowsound="run_snow", mudsound = "run_mud"	} },

	{ GROUND.WOODFLOOR,	{ name = "blocky",		noise_texture = "levels/textures/noise_woodfloor.tex",				runsound="run_wood",		walksound="walk_wood",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.CHECKER,	{ name = "blocky",		noise_texture = "levels/textures/noise_checker.tex",				runsound="run_marble",		walksound="walk_marble",	snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.SNAKESKIN,	{ name = "carpet",		noise_texture = "levels/textures/noise_snakeskinfloor.tex",			runsound="run_carpet",		walksound="walk_carpet",	snowsound="run_snow", mudsound = "run_mud"		} },
	{ GROUND.CARPET,	{ name = "carpet",		noise_texture = "levels/textures/noise_carpet.tex",					runsound="run_carpet",		walksound="walk_carpet",	snowsound="run_snow", mudsound = "run_mud"	} },
	
	{ GROUND.BRICK_GLOW,{ name = "cave",		noise_texture = "levels/textures/noise_ruinsbrick.tex",				runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.BRICK,		{ name = "cave",		noise_texture = "levels/textures/noise_ruinsbrickglow.tex",			runsound="run_moss",		walksound="walk_moss",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.TILES_GLOW,{ name = "cave",		noise_texture = "levels/textures/noise_ruinstile.tex",				runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.TILES,		{ name = "cave",		noise_texture = "levels/textures/noise_ruinstileglow.tex",			runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.TRIM_GLOW,	{ name = "cave",		noise_texture = "levels/textures/noise_ruinstrim.tex",				runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.TRIM,		{ name = "cave",		noise_texture = "levels/textures/noise_ruinstrimglow.tex",			runsound="run_dirt",		walksound="walk_dirt",		snowsound="run_ice", mudsound = "run_mud"		} },
	{ GROUND.FLOOD,		{ name = "flood",		noise_texture = "levels/textures/Ground_noise_flood.tex",runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.MANGROVE_SHORE,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_water_mangrove.tex",	runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_SHORE,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_noise_water_shallow.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },	
	{ GROUND.OCEAN_SHALLOW,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_noise_water_shallow.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_CORAL,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_water_coral.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_CORAL_SHORE,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_water_coral.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_MEDIUM,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_noise_water_medium.tex",	runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_DEEP,	{ name = "water_medium",	noise_texture = "levels/textures/Ground_noise_water_deep.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
	{ GROUND.OCEAN_SHIPGRAVEYARD,{ name = "water_medium",	noise_texture = "levels/textures/Ground_water_graveyard.tex",		runsound="run_marsh",		walksound="walk_marsh",		snowsound="run_snow", mudsound = "run_mud"	} },
}


local WALL_PROPERTIES =
{
	{ GROUND.UNDERGROUND,	{ name = "falloff", noise_texture = "images/square.tex" } },
	{ GROUND.WALL_MARSH,	{ name = "walls", 	noise_texture = "images/square.tex" } },--"levels/textures/wall_marsh_01.tex" } },
	{ GROUND.WALL_ROCKY,	{ name = "walls", 	noise_texture = "images/square.tex" } },--"levels/textures/wall_rock_01.tex" } },
	{ GROUND.WALL_DIRT,		{ name = "walls", 	noise_texture = "images/square.tex" } },--"levels/textures/wall_dirt_01.tex" } },

	{ GROUND.WALL_CAVE,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_cave_01.tex" } },
	{ GROUND.WALL_FUNGUS,	{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_fungus_01.tex" } },
	{ GROUND.WALL_SINKHOLE, { name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_sinkhole_01.tex" } },
	{ GROUND.WALL_MUD,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_mud_01.tex" } },
	{ GROUND.WALL_TOP,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/cave_topper.tex" } },
	{ GROUND.WALL_WOOD,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/cave_topper.tex" } },

	{ GROUND.WALL_HUNESTONE_GLOW,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_cave_01.tex" } },
	{ GROUND.WALL_HUNESTONE,	{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_fungus_01.tex" } },
	{ GROUND.WALL_STONEEYE_GLOW, { name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_sinkhole_01.tex" } },
	{ GROUND.WALL_STONEEYE,		{ name = "walls",	noise_texture = "images/square.tex" } },--"levels/textures/wall_mud_01.tex" } },
}

local underground_layers =
{
	{ GROUND.UNDERGROUND, { name = "falloff", noise_texture = "images/square.tex" } },
}

local GROUND_CREEP_PROPERTIES = {
	{ 1, { name = "web", noise_texture = "levels/textures/web_noise.tex" } },
}

local FLOODING_PROPERTIES = {
	{ 2, { name = "flood", noise_texture = "levels/textures/Ground_noise_flood.tex" } },
	--{ 2, { name = "beach", noise_texture = "levels/textures/Ground_noise_sand.tex" } },
}

function GroundImage( name )
	return "levels/tiles/" .. name .. ".tex"
end

function GroundAtlas( name )
	return "levels/tiles/" .. name .. ".xml"
end

local function AddAssets( assets, layers )
	for i, data in ipairs( layers ) do
		local tile_type, properties = unpack( data )
		table.insert( assets, Asset( "IMAGE", properties.noise_texture ) )
		table.insert( assets, Asset( "IMAGE", GroundImage( properties.name ) ) )
		table.insert( assets, Asset( "FILE", GroundAtlas( properties.name ) ) )
	end
end

local assets = {}
AddAssets( assets, WALL_PROPERTIES )
AddAssets( assets, GROUND_PROPERTIES )
AddAssets( assets, underground_layers ) 
AddAssets( assets, GROUND_CREEP_PROPERTIES )




function GetTileInfo( tile )
	for k, data in ipairs( GROUND_PROPERTIES ) do
		local tile_type, tile_info = unpack( data )
		if tile == tile_type then
			return tile_info
		end
	end
	return nil
end


local WEB_FOOTSTEP_SOUNDS = {
	[CREATURE_SIZE.SMALL]	=	{ runsound = "run_web_small",		walksound = "walk_web_small" },
	[CREATURE_SIZE.MEDIUM]	=	{ runsound = "run_web",				walksound = "walk_web" },
	[CREATURE_SIZE.LARGE]	=	{ runsound = "run_web_large",		walksound = "walk_web_large" },
}


function PlayFootstep(inst, volume)
	volume = volume or 1
	
    local sound = inst.SoundEmitter
    if sound then
        local tile, tileinfo = inst:GetCurrentTileType()
        
        if tile and tileinfo then
			local x, y, z = inst.Transform:GetWorldPosition()
			local ontar = inst.slowing_objects and next(inst.slowing_objects)
			local oncreep = GetWorld().GroundCreep:OnCreep( x, y, z )
			local onflood = GetWorld().Flooding and GetWorld().Flooding:OnFlood( x, y, z )
			local onsnow = GetSeasonManager() and GetSeasonManager():GetSnowPercent() > 0.15
			local onmud = GetWorld().components.moisturemanager:GetWorldMoisture() > 15
			--this is only for playerd for the time being because isonroad is suuuuuuuper slow.
			local onroad = inst:HasTag("player") and RoadManager ~= nil and RoadManager:IsOnRoad( x, 0, z )
			if onroad then
				tile = GROUND.ROAD
				tileinfo = GetTileInfo( GROUND.ROAD )
			end

			local footstep_path = inst.footstep_path_override or "dontstarve/movement/"

			local creature_size = CREATURE_SIZE.MEDIUM
			local size_affix = ""
			if inst:HasTag("smallcreature") then
				creature_size = CREATURE_SIZE.SMALL
				size_affix = "_small"
			elseif inst:HasTag("largecreature") then
				creature_size = CREATURE_SIZE.LARGE
				size_affix = "_large"
			end
			
			if onsnow then
				sound:PlaySound(footstep_path .. tileinfo.snowsound .. size_affix, nil, volume)
			elseif onmud then
				sound:PlaySound(footstep_path .. tileinfo.mudsound .. size_affix, nil, volume)
			else
				if inst.sg and inst.sg:HasStateTag("running") then
					sound:PlaySound(footstep_path .. tileinfo.runsound .. size_affix, nil, volume)
				else
					sound:PlaySound(footstep_path .. tileinfo.walksound .. size_affix, nil, volume)
				end
			end

			if oncreep then
				sound:PlaySound(footstep_path .. WEB_FOOTSTEP_SOUNDS[ creature_size ].runsound, nil, volume)
			end
			if onflood then
				sound:PlaySound(footstep_path .. WEB_FOOTSTEP_SOUNDS[ creature_size ].runsound, nil, volume) --play this for now
			end

			if ontar then
				sound:PlaySound(footstep_path .. tileinfo.mudsound .. size_affix, nil, volume)
			end			
        end
    end
end

return 
{
	ground = GROUND_PROPERTIES,
	creep = GROUND_CREEP_PROPERTIES,
	flooding = FLOODING_PROPERTIES,
	wall = WALL_PROPERTIES,
	underground = underground_layers,
	assets = assets,
}
