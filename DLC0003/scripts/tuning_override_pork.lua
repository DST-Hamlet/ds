
local tuning_backups = {}

local function OverrideTuningVariables(tuning)
	for k,v in pairs(tuning) do
		tuning_backups[k] = TUNING[k] 
		TUNING[k] = v
	end
end

local function ResetTuningVariables()
	for k,v in pairs(tuning_backups) do
		TUNING[k] = v
	end
end

local function GetSeasonLengthFriendly(difficulty, default)
	local length = 0
	if difficulty == "random" then
		local rand = math.random()
		if rand <= 1/6 then
			difficulty = "noseason"
		elseif rand <= 2/6 then
			difficulty = "veryshortseason"
		elseif rand <= 3/6 then
			difficulty = "shortseason"
		elseif rand <= 4/6 then
			difficulty = "longseason"
		elseif rand <= 5/6 then
			difficulty = "verylongseason"
		else
			difficulty = "default"
		end
	end
	if difficulty == "noseason" then
		length = 0
	elseif difficulty == "veryshortseason" then
		length = TUNING.PLATEAU_SEASON_LENGTH_VERYSHORT
	elseif difficulty == "shortseason" then
		length = TUNING.PLATEAU_SEASON_LENGTH_SHORT
	elseif difficulty == "longseason" then
		length = TUNING.PLATEAU_SEASON_LENGTH_LONG
	elseif difficulty == "verylongseason" then
		length = TUNING.PLATEAU_SEASON_LENGTH_VERYLONG
	else
		length = default
	end
	return length
end

local TUNING_OVERRIDES = 
{
	["hounds"] = 	{
						doit = 	function(difficulty)
							--local Hounded = require("components/hounded")
							local hounded = GetWorld().components.hounded
							if hounded then
								-- if difficulty == "never" then
								-- 	hounded:SpawnModeNever()
								-- elseif difficulty == "always" then
								-- 	hounded:SpawnModeHeavy()
								-- elseif difficulty == "often" then
								-- 	hounded:SpawnModeMed()
								-- elseif difficulty == "rare" then
								-- 	hounded:SpawnModeLight()
								-- end
								hounded:SpawnModeNever()
								--never spawn hounds in porkland, for now. 
								--possible issue when travelling to shipwrecked or base game. 
							end
						end,
					},
	["deerclops"] = 	{
							doit = 	function(difficulty)									
								local basehassler = GetWorld().components.basehassler
								if basehassler then
									if difficulty == "never" then
										basehassler:OverrideAttacksPerSeason("DEERCLOPS", 0)
										basehassler:OverrideAttackDuringOffSeason("DEERCLOPS", false)
										basehassler:OverrideAttackChance("DEERCLOPS", 0)
									elseif difficulty == "rare" then
										basehassler:OverrideAttacksPerSeason("DEERCLOPS", 1)
										basehassler:OverrideAttackDuringOffSeason("DEERCLOPS", false)
										basehassler:OverrideAttackChance("DEERCLOPS", .33)
									elseif difficulty == "often" then
										basehassler:OverrideAttacksPerSeason("DEERCLOPS", 1)
										basehassler:OverrideAttackDuringOffSeason("DEERCLOPS", false)
										basehassler:OverrideAttackChance("DEERCLOPS", 1.1)
										basehassler:OverrideMinSpawnDay("DEERCLOPS", nil)
									elseif difficulty == "always" then
										basehassler:OverrideAttacksPerSeason("DEERCLOPS", 1)
										basehassler:OverrideAttackDuringOffSeason("DEERCLOPS", true)
										basehassler:OverrideAttackChance("DEERCLOPS", 1.1)
										basehassler:OverrideMinSpawnDay("DEERCLOPS", nil)
									end
								end
							end,
						},
	["bearger"] = 	{
							doit = 	function(difficulty)									
								local basehassler = GetWorld().components.basehassler
								if basehassler then
									if difficulty == "never" then
										basehassler:OverrideAttacksPerSeason("BEARGER", 0)
										basehassler:OverrideAttackDuringOffSeason("BEARGER", false)
										basehassler:OverrideAttackChance("BEARGER", 0)
									elseif difficulty == "rare" then
										basehassler:OverrideAttacksPerSeason("BEARGER", 1)
										basehassler:OverrideAttackDuringOffSeason("BEARGER", false)
										basehassler:OverrideAttackChance("BEARGER", .33)
									elseif difficulty == "often" then
										basehassler:OverrideAttacksPerSeason("BEARGER", 1)
										basehassler:OverrideAttackDuringOffSeason("BEARGER", false)
										basehassler:OverrideAttackChance("BEARGER", 1.1)
										basehassler:OverrideMinSpawnDay("BEARGER", nil)
									elseif difficulty == "always" then
										basehassler:OverrideAttacksPerSeason("BEARGER", 1)
										basehassler:OverrideAttackDuringOffSeason("BEARGER", true)
										basehassler:OverrideAttackChance("BEARGER", 1.1)
										basehassler:OverrideMinSpawnDay("BEARGER", nil)
									end
								end
							end,
						},
	["goosemoose"] = 	{
							doit = 	function(difficulty)									
								local basehassler = GetWorld().components.basehassler
								if basehassler then
									if difficulty == "never" then
										basehassler:OverrideAttacksPerSeason("GOOSEMOOSE", 0)
										basehassler:OverrideAttackDuringOffSeason("GOOSEMOOSE", false)
										basehassler:OverrideAttackChance("GOOSEMOOSE", 0)
									elseif difficulty == "rare" then
										basehassler:OverrideAttacksPerSeason("GOOSEMOOSE", 1)
										basehassler:OverrideAttackDuringOffSeason("GOOSEMOOSE", false)
										basehassler:OverrideAttackChance("GOOSEMOOSE", .33)
									elseif difficulty == "often" then
										basehassler:OverrideAttacksPerSeason("GOOSEMOOSE", 1)
										basehassler:OverrideAttackDuringOffSeason("GOOSEMOOSE", false)
										basehassler:OverrideAttackChance("GOOSEMOOSE", 1.1)
										basehassler:OverrideMinSpawnDay("GOOSEMOOSE", nil)
									elseif difficulty == "always" then
										basehassler:OverrideAttacksPerSeason("GOOSEMOOSE", 1)
										basehassler:OverrideAttackDuringOffSeason("GOOSEMOOSE", true)
										basehassler:OverrideAttackChance("GOOSEMOOSE", 1.1)
										basehassler:OverrideMinSpawnDay("GOOSEMOOSE", nil)
									end
								end
							end,
						},
	["dragonfly"] = 	{
							doit = 	function(difficulty)									
								local basehassler = GetWorld().components.basehassler
								if basehassler then
									if difficulty == "never" then
										basehassler:OverrideAttacksPerSeason("DRAGONFLY", 0)
										basehassler:OverrideAttackDuringOffSeason("DRAGONFLY", false)
										basehassler:OverrideAttackChance("DRAGONFLY", 0)
									elseif difficulty == "rare" then
										basehassler:OverrideAttacksPerSeason("DRAGONFLY", 1)
										basehassler:OverrideAttackDuringOffSeason("DRAGONFLY", false)
										basehassler:OverrideAttackChance("DRAGONFLY", .33)
									elseif difficulty == "often" then
										basehassler:OverrideAttacksPerSeason("DRAGONFLY", 1)
										basehassler:OverrideAttackDuringOffSeason("DRAGONFLY", false)
										basehassler:OverrideAttackChance("DRAGONFLY", 1.1)
										basehassler:OverrideMinSpawnDay("DRAGONFLY", nil)
									elseif difficulty == "always" then
										basehassler:OverrideAttacksPerSeason("DRAGONFLY", 1)
										basehassler:OverrideAttackDuringOffSeason("DRAGONFLY", true)
										basehassler:OverrideAttackChance("DRAGONFLY", 1.1)
										basehassler:OverrideMinSpawnDay("DRAGONFLY", nil)
									end
								end
							end,
						},
	["twister"] = 	{
							doit = 	function(difficulty)
								local basehassler = GetWorld().components.basehassler
								if basehassler then
									if difficulty == "never" then
										basehassler:OverrideAttacksPerSeason("TWISTER", 0)
										basehassler:OverrideAttackDuringOffSeason("TWISTER", false)
										basehassler:OverrideAttackChance("TWISTER", 0)
									elseif difficulty == "rare" then
										basehassler:OverrideAttacksPerSeason("TWISTER", 1)
										basehassler:OverrideAttackDuringOffSeason("TWISTER", false)
										basehassler:OverrideAttackChance("TWISTER", .33)
									elseif difficulty == "often" then
										basehassler:OverrideAttacksPerSeason("TWISTER", 1)
										basehassler:OverrideAttackDuringOffSeason("TWISTER", false)
										basehassler:OverrideAttackChance("TWISTER", 1.1)
										basehassler:OverrideMinSpawnDay("TWISTER", nil)
									elseif difficulty == "always" then
										basehassler:OverrideAttacksPerSeason("TWISTER", 1)
										basehassler:OverrideAttackDuringOffSeason("TWISTER", true)
										basehassler:OverrideAttackChance("TWISTER", 1.1)
										basehassler:OverrideMinSpawnDay("TWISTER", nil)
									end
								end
							end,
						},
	["tigershark"] = 	{
							doit = 	function(difficulty)
								local tigersharker = GetWorld().components.tigersharker
								if tigersharker then
									if difficulty == "never" then
										tigersharker:SetChanceModifier(-1.0, -1.0)
										tigersharker:SetCooldownModifier(0.0, 0.0)
									elseif difficulty == "rare" then
										tigersharker:SetChanceModifier(0.5, 0.5)
										tigersharker:SetCooldownModifier(1.5, 1.5)
									elseif difficulty == "often" then
										tigersharker:SetChanceModifier(1.5, 1.5)
										tigersharker:SetCooldownModifier(0.5, 0.5)
									elseif difficulty == "always" then
										tigersharker:SetChanceModifier(2.0, 2.0)
										tigersharker:SetCooldownModifier(0.25, 0.25)
									end
								end
							end,
						},
	["kraken"] = 	{
							doit = 	function(difficulty)
								local krakener = GetPlayer().components.krakener
								if krakener then
									if difficulty == "never" then
										krakener:SetChanceModifier(-1.0)
										krakener:SetCooldownModifier(0.0)
									elseif difficulty == "rare" then
										krakener:SetChanceModifier(0.5)
										krakener:SetCooldownModifier(1.5)
									elseif difficulty == "often" then
										krakener:SetChanceModifier(1.5)
										krakener:SetCooldownModifier(0.5)
									elseif difficulty == "always" then
										krakener:SetChanceModifier(2.0)
										krakener:SetCooldownModifier(0.25)
									end
								end
							end,
						},
	["perd"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {PERD_SPAWNCHANCE = 0, 	PERD_ATTACK_PERIOD = 1},
								["rare"] = 	 {PERD_SPAWNCHANCE = 0.1, 	PERD_ATTACK_PERIOD = 1},
								["often"] =  {PERD_SPAWNCHANCE = 0.2,	PERD_ATTACK_PERIOD = 1},
								["always"] = {PERD_SPAWNCHANCE = 0.4, 	PERD_ATTACK_PERIOD = 1},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},
	["deciduousmonster"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {DECID_MONSTER_MIN_DAY = 9999, DECID_MONSTER_SPAWN_CHANCE_BASE = -1, DECID_MONSTER_SPAWN_CHANCE_LOW = -1, DECID_MONSTER_SPAWN_CHANCE_MED = -1, DECID_MONSTER_SPAWN_CHANCE_HIGH = -1},
								["rare"] = 	 {DECID_MONSTER_MIN_DAY = 5, DECID_MONSTER_SPAWN_CHANCE_BASE = .015, DECID_MONSTER_SPAWN_CHANCE_LOW = .04, DECID_MONSTER_SPAWN_CHANCE_MED = .075, DECID_MONSTER_SPAWN_CHANCE_HIGH = .167},
								["often"] =  {DECID_MONSTER_MIN_DAY = 2, DECID_MONSTER_SPAWN_CHANCE_BASE = .07, DECID_MONSTER_SPAWN_CHANCE_LOW = .15, DECID_MONSTER_SPAWN_CHANCE_MED = .33, DECID_MONSTER_SPAWN_CHANCE_HIGH = .5},
								["always"] = {DECID_MONSTER_MIN_DAY = 1, DECID_MONSTER_SPAWN_CHANCE_BASE = .2, DECID_MONSTER_SPAWN_CHANCE_LOW = .33, DECID_MONSTER_SPAWN_CHANCE_MED = .5, DECID_MONSTER_SPAWN_CHANCE_HIGH = .67},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},
	["warg"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {HUNT_ALTERNATE_BEAST_CHANCE_MIN = -1, HUNT_ALTERNATE_BEAST_CHANCE_MAX = 0},
								["rare"] = 	 {HUNT_ALTERNATE_BEAST_CHANCE_MIN = .025, HUNT_ALTERNATE_BEAST_CHANCE_MAX = .167},
								["often"] =  {HUNT_ALTERNATE_BEAST_CHANCE_MIN = .1, HUNT_ALTERNATE_BEAST_CHANCE_MAX = .5},
								["always"] = {HUNT_ALTERNATE_BEAST_CHANCE_MIN = .2, HUNT_ALTERNATE_BEAST_CHANCE_MAX = .67},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},				
	["hunt"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {HUNT_COOLDOWN = -1, HUNT_COOLDOWNDEVIATION = 0, HUNT_RESET_TIME = 0, HUNT_SPRING_RESET_TIME = -1},
								["rare"] = 	 {HUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*2.4, HUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.3, HUNT_RESET_TIME = 5, HUNT_SPRING_RESET_TIME = TUNING.TOTAL_DAY_TIME*5},
								["often"] =  {HUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*.6, HUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.3, HUNT_RESET_TIME = 5, HUNT_SPRING_RESET_TIME = TUNING.TOTAL_DAY_TIME*2},
								["always"] = {HUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*.3, HUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.2, HUNT_RESET_TIME = 5, HUNT_SPRING_RESET_TIME = TUNING.TOTAL_DAY_TIME*1},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},				
	["whalehunt"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {WHALEHUNT_COOLDOWN = -1, WHALEHUNT_COOLDOWNDEVIATION = 0, WHALEHUNT_RESET_TIME = 0, WHALEHUNT_RESET_TIME = -1},
								["rare"] = 	 {WHALEHUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*2.4, WHALEHUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.3, WHALEHUNT_RESET_TIME = 5, WHALEHUNT_RESET_TIME = TUNING.TOTAL_DAY_TIME*5},
								["often"] =  {WHALEHUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*.6, WHALEHUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.3, WHALEHUNT_RESET_TIME = 5, WHALEHUNT_RESET_TIME = TUNING.TOTAL_DAY_TIME*2},
								["always"] = {WHALEHUNT_COOLDOWN = TUNING.TOTAL_DAY_TIME*.3, WHALEHUNT_COOLDOWNDEVIATION = TUNING.TOTAL_DAY_TIME*.2, WHALEHUNT_RESET_TIME = 5, WHALEHUNT_RESET_TIME = TUNING.TOTAL_DAY_TIME*1},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},
	["krampus"] = 	{
					doit = 	function(difficulty)
						local tuning_vars = {
								["never"] =  {KRAMPUS_THRESHOLD = -1, KRAMPUS_THRESHOLD_VARIANCE = 0, KRAMPUS_INCREASE_LVL1 = -1, KRAMPUS_INCREASE_LVL2 = -1, KRAMPUS_INCREASE_RAMP = -1, KRAMPUS_NAUGHTINESS_DECAY_PERIOD = 1},
								["rare"] = 	 {KRAMPUS_THRESHOLD = 45, KRAMPUS_THRESHOLD_VARIANCE = 30, KRAMPUS_INCREASE_LVL1 = 75, KRAMPUS_INCREASE_LVL2 = 125, KRAMPUS_INCREASE_RAMP = 1, KRAMPUS_NAUGHTINESS_DECAY_PERIOD = 30},
								["often"] =  {KRAMPUS_THRESHOLD = 20, KRAMPUS_THRESHOLD_VARIANCE = 15, KRAMPUS_INCREASE_LVL1 = 37, KRAMPUS_INCREASE_LVL2 = 75, KRAMPUS_INCREASE_RAMP = 3, KRAMPUS_NAUGHTINESS_DECAY_PERIOD = 90},
								["always"] = {KRAMPUS_THRESHOLD = 10, KRAMPUS_THRESHOLD_VARIANCE = 5, KRAMPUS_INCREASE_LVL1 = 25, KRAMPUS_INCREASE_LVL2 = 50, KRAMPUS_INCREASE_RAMP = 4, KRAMPUS_NAUGHTINESS_DECAY_PERIOD = 120},
							}
						OverrideTuningVariables(tuning_vars[difficulty])
					end,
				},								
	["butterfly"] = {
						doit = 	function(difficulty)
							local butterflies = GetWorld().components.butterflyspawner
							if butterflies then
								if difficulty == "never" then
									butterflies:SpawnModeNever()
								elseif difficulty == "always" then
									butterflies:SpawnModeHeavy()
								elseif difficulty == "often" then
									butterflies:SpawnModeMed()
								elseif difficulty == "rare" then
									butterflies:SpawnModeLight()
								end
							end								
						end,
					},
	["flowers"] = 	{
						doit = 	function(difficulty)
							local flowers = GetWorld().components.flowerspawner
							if flowers then
								if difficulty == "never" then
									flowers:SpawnModeNever()
								elseif difficulty == "always" then
									flowers:SpawnModeHeavy()
								elseif difficulty == "often" then
									flowers:SpawnModeMed()
								elseif difficulty == "rare" then
									flowers:SpawnModeLight()
								end
							end								
						end,
					},
	["flowers_rainforest"] = 	{
						doit = 	function(difficulty)
							local flowers = GetWorld().components.flowerspawner_rainforest
							if flowers then
								if difficulty == "never" then
									flowers:SpawnModeNever()
								elseif difficulty == "always" then
									flowers:SpawnModeHeavy()
								elseif difficulty == "often" then
									flowers:SpawnModeMed()
								elseif difficulty == "rare" then
									flowers:SpawnModeLight()
								end
							end								
						end,
					},					
	["birds"] = 	{
						doit = 	function(difficulty)						
							local birds = GetWorld().components.birdspawner
							if birds then							
								if difficulty == "never" then
									birds:SpawnModeNever()
								elseif difficulty == "always" then
									birds:SpawnModeHeavy()
								elseif difficulty == "often" then
									birds:SpawnModeMed()
								elseif difficulty == "rare" then
									birds:SpawnModeLight()
								end
							end								
						end,
					},
	["seagull"] = 	{
						doit = 	function(difficulty)								
							local birds = GetWorld().components.birdspawner
							if birds then
								if difficulty == "never" then
									birds:SeagulSpawnModeNever()
								end
							end																
						end,
					},
	["penguins"] = 	{
						doit = 	function(difficulty)
							local penguins = GetWorld().components.penguinspawner
							if penguins then
								if difficulty == "never" then
									penguins:SpawnModeNever()
								elseif difficulty == "always" then
									penguins:SpawnModeHeavy()
								elseif difficulty == "often" then
									penguins:SpawnModeMed()
								elseif difficulty == "rare" then
									penguins:SpawnModeLight()
								end
							end								
						end,
					},					
	["lureplants"] = 	{
							doit = 	function(difficulty)
								local lureplants = GetWorld().components.lureplantspawner
								if lureplants then
									if difficulty == "never" then
										lureplants:SpawnModeNever()
									elseif difficulty == "always" then
										lureplants:SpawnModeHeavy()
									elseif difficulty == "often" then
										lureplants:SpawnModeMed()
									elseif difficulty == "rare" then
										lureplants:SpawnModeLight()
									end
								end
							end,
						},
	["mosquitos"] = 	{
							doit = 	function(difficulty)
								local mosquitos = GetWorld().components.mosquitospawner
								if mosquitos then
									if difficulty == "never" then
										mosquitos:SpawnModeNever()
									elseif difficulty == "always" then
										mosquitos:SpawnModeHeavy()
									elseif difficulty == "often" then
										mosquitos:SpawnModeMed()
									elseif difficulty == "rare" then
										mosquitos:SpawnModeLight()
									end
								end
							end,
						},
	["beefaloheat"] = 	{
							doit = 	function(difficulty)
								local tuning_vars = {
										["never"] =  {BEEFALO_MATING_SEASON_LENGTH = 0, 	BEEFALO_MATING_SEASON_WAIT = -1},
										["rare"] = 	 {BEEFALO_MATING_SEASON_LENGTH = 2, 	BEEFALO_MATING_SEASON_WAIT = 18},
										["often"] =  {BEEFALO_MATING_SEASON_LENGTH = 4,     BEEFALO_MATING_SEASON_WAIT = 6},
										["always"] = {BEEFALO_MATING_SEASON_LENGTH = -1, 	BEEFALO_MATING_SEASON_WAIT = 0},
									}
								OverrideTuningVariables(tuning_vars[difficulty])
							end,
						},
	["liefs"] = 	{
						doit = 	function(difficulty)
							local tuning_vars = {
									["never"] =  {LEIF_MIN_DAY = 9999, LEIF_PERCENT_CHANCE = 0},
									["rare"] = 	 {LEIF_MIN_DAY = 5, LEIF_PERCENT_CHANCE = 1/100},
									["often"] =  {LEIF_MIN_DAY = 2, LEIF_PERCENT_CHANCE = 1/70},
									["always"] = {LEIF_MIN_DAY = 1, LEIF_PERCENT_CHANCE = 1/55},
								}
							OverrideTuningVariables(tuning_vars[difficulty])
						end
					},
	["treeguard"] = 	{
						doit = 	function(difficulty)
							local tuning_vars = {
									["never"] =  {PALMTREEGUARD_MIN_DAY = 9999, PALMTREEGUARD_PERCENT_CHANCE = 0},
									["rare"] = 	 {PALMTREEGUARD_MIN_DAY = 5, PALMTREEGUARD_PERCENT_CHANCE = 1/100},
									["often"] =  {PALMTREEGUARD_MIN_DAY = 2, PALMTREEGUARD_PERCENT_CHANCE = 1/70},
									["always"] = {PALMTREEGUARD_MIN_DAY = 1, PALMTREEGUARD_PERCENT_CHANCE = 1/55},
								}
							OverrideTuningVariables(tuning_vars[difficulty])
						end
					},
	["day"] = 	{
					doit =  function(data)
						local lookup = { 
							["onlyday"]={
									day = 3, dusk = 0, night = 0
									-- autumn={day=16,  dusk=0, night=0},
								},
							["onlydusk"]={
									day = 0, dusk = 3, night = 0
									-- autumn={day=0,  dusk=16, night=0},
								},
							["onlynight"]={
									day = 0, dusk = 0, night = 3
									-- autumn={day=0,  dusk=0,  night=16},
								},
							["default"]={
									day = 1, dusk = 1, night = 1
									-- autumn={day=8,  dusk=6,  night=2},
									-- winter={day=5,  dusk=5,  night=6},
									-- spring={day=5,  dusk=8,  night=3},
									-- summer={day=11, dusk=1,  night=4},
								},
							["longday"]={
									day = 1.6, dusk = 0.7, night = 0.7
									-- autumn={day=11, dusk=3,  night=2},
									-- winter={day=8,  dusk=4,  night=4},
									-- spring={day=8,  dusk=6,  night=2},
									-- summer={day=14, dusk=1,  night=1},
								},
							["longdusk"]={
									day = 0.7, dusk = 1.6, night = 0.7
									-- autumn={day=5,  dusk=9,  night=2},
									-- winter={day=4,  dusk=8,  night=4},
									-- spring={day=3,  dusk=11, night=2},
									-- summer={day=8,  dusk=4,  night=4},
								},
							["longnight"]={
									day = 0.7, dusk = 0.7, night = 1.6
									-- autumn={day=6,  dusk=5,  night=5},
									-- winter={day=4,  dusk=3,  night=9},
									-- spring={day=4,  dusk=6,  night=6},
									-- summer={day=8,  dusk=1,  night=7},
								},
							["noday"]={ 
									day = 0, dusk = 1.5, night = 1.5
									-- autumn={day=0,  dusk=12, night=4},
									-- winter={day=0,  dusk=10, night=6},
									-- spring={day=8,  dusk=11, night=5},
									-- summer={day=0,  dusk=14, night=2},
								},
							["nodusk"]={
									day = 1.5, dusk = 0, night = 1.5
									-- autumn={day=11, dusk=0,  night=5},
									-- winter={day=9,  dusk=0,  night=7},
									-- spring={day=11, dusk=0,  night=5},
									-- summer={day=13, dusk=0,  night=3},
								},
							["nonight"]={
									day = 1.5, dusk = 1.5, night = 0
									-- autumn={day=11, dusk=5,  night=0},
									-- winter={day=10, dusk=6,  night=0},
									-- spring={day=9,  dusk=7,  night=0},
									-- summer={day=14, dusk=2,  night=0},
								}
						}

						local override = lookup[data]
						
						-- local autumnsegs = lookup[data].autumn
						-- local wintersegs = lookup[data].winter or autumnsegs
						-- local springsegs = lookup[data].spring or autumnsegs
						-- local summersegs = lookup[data].summer or autumnsegs
						if GetSeasonManager() then
							--GetSeasonManager():SetSegs(autumnsegs, wintersegs, springsegs, summersegs)
							GetSeasonManager():SetModifer(override)
							GetSeasonManager():UpdateSegs()
						end
						--GetClock():SetSegs(autumnsegs.day, autumnsegs.dusk, autumnsegs.night)
					end
				},
	["autumn"] = {
					doit = function(difficulty)
						local seasonmgr = GetSeasonManager()
						if not seasonmgr then return end
						if difficulty == "random" then
							local rand = math.random()
							if rand <= 1/6 then
								difficulty = "noseason"
							elseif rand <= 2/6 then
								difficulty = "veryshortseason"
							elseif rand <= 3/6 then
								difficulty = "shortseason"
							elseif rand <= 4/6 then
								difficulty = "longseason"
							elseif rand <= 5/6 then
								difficulty = "verylongseason"
							else
								difficulty = "default"
							end
						end
						if difficulty == "noseason" then
							seasonmgr:SetAutumnLength(0)
						elseif difficulty == "veryshortseason" then
							seasonmgr:SetAutumnLength(TUNING.SEASON_LENGTH_FRIENDLY_VERYSHORT)
						elseif difficulty == "shortseason" then
							seasonmgr:SetAutumnLength(TUNING.SEASON_LENGTH_FRIENDLY_SHORT)
						elseif difficulty == "longseason" then
							seasonmgr:SetAutumnLength(TUNING.SEASON_LENGTH_FRIENDLY_LONG)
						elseif difficulty == "verylongseason" then
							seasonmgr:SetAutumnLength(TUNING.SEASON_LENGTH_FRIENDLY_VERYLONG)
						else
							seasonmgr:SetAutumnLength(TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT)
						end
					end
				},
	["winter"] = {
					doit = function(difficulty)
						local seasonmgr = GetSeasonManager()
						if not seasonmgr then return end
						if difficulty == "random" then
							local rand = math.random()
							if rand <= 1/6 then
								difficulty = "noseason"
							elseif rand <= 2/6 then
								difficulty = "veryshortseason"
							elseif rand <= 3/6 then
								difficulty = "shortseason"
							elseif rand <= 4/6 then
								difficulty = "longseason"
							elseif rand <= 5/6 then
								difficulty = "verylongseason"
							else
								difficulty = "default"
							end
						end
						if difficulty == "noseason" then
							seasonmgr:SetWinterLength(0)
						elseif difficulty == "veryshortseason" then
							seasonmgr:SetWinterLength(TUNING.SEASON_LENGTH_HARSH_VERYSHORT)
						elseif difficulty == "shortseason" then
							seasonmgr:SetWinterLength(TUNING.SEASON_LENGTH_HARSH_SHORT)
						elseif difficulty == "longseason" then
							seasonmgr:SetWinterLength(TUNING.SEASON_LENGTH_HARSH_LONG)
						elseif difficulty == "verylongseason" then
							seasonmgr:SetWinterLength(TUNING.SEASON_LENGTH_HARSH_VERYLONG)
						else
							seasonmgr:SetWinterLength(TUNING.SEASON_LENGTH_HARSH_DEFAULT)
						end
					end
				},
	["spring"] = {
					doit = function(difficulty)
						local seasonmgr = GetSeasonManager()
						if not seasonmgr then return end
						if difficulty == "random" then
							local rand = math.random()
							if rand <= 1/6 then
								difficulty = "noseason"
							elseif rand <= 2/6 then
								difficulty = "veryshortseason"
							elseif rand <= 3/6 then
								difficulty = "shortseason"
							elseif rand <= 4/6 then
								difficulty = "longseason"
							elseif rand <= 5/6 then
								difficulty = "verylongseason"
							else
								difficulty = "default"
							end
						end
						if difficulty == "noseason" then
							seasonmgr:SetSpringLength(0)
						elseif difficulty == "veryshortseason" then
							seasonmgr:SetSpringLength(TUNING.SEASON_LENGTH_FRIENDLY_VERYSHORT)
						elseif difficulty == "shortseason" then
							seasonmgr:SetSpringLength(TUNING.SEASON_LENGTH_FRIENDLY_SHORT)
						elseif difficulty == "longseason" then
							seasonmgr:SetSpringLength(TUNING.SEASON_LENGTH_FRIENDLY_LONG)
						elseif difficulty == "verylongseason" then
							seasonmgr:SetSpringLength(TUNING.SEASON_LENGTH_FRIENDLY_VERYLONG)
						else
							seasonmgr:SetSpringLength(TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT)
						end
					end
				},
	["summer"] = {
					doit = function(difficulty)
						local seasonmgr = GetSeasonManager()
						if not GetSeasonManager() then return end
						if difficulty == "random" then
							local rand = math.random()
							if rand <= 1/6 then
								difficulty = "noseason"
							elseif rand <= 2/6 then
								difficulty = "veryshortseason"
							elseif rand <= 3/6 then
								difficulty = "shortseason"
							elseif rand <= 4/6 then
								difficulty = "longseason"
							elseif rand <= 5/6 then
								difficulty = "verylongseason"
							else
								difficulty = "default"
							end
						end
						if difficulty == "noseason" then
							seasonmgr:SetSummerLength(0)
						elseif difficulty == "veryshortseason" then
							seasonmgr:SetSummerLength(TUNING.SEASON_LENGTH_HARSH_VERYSHORT)
						elseif difficulty == "shortseason" then
							seasonmgr:SetSummerLength(TUNING.SEASON_LENGTH_HARSH_SHORT)
						elseif difficulty == "longseason" then
							seasonmgr:SetSummerLength(TUNING.SEASON_LENGTH_HARSH_LONG)
						elseif difficulty == "verylongseason" then
							seasonmgr:SetSummerLength(TUNING.SEASON_LENGTH_HARSH_VERYLONG)
						else
							seasonmgr:SetSummerLength(TUNING.SEASON_LENGTH_HARSH_DEFAULT)
						end
					end
				},
	["mild_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetMildLength(difficulty)
						else
							local length = GetSeasonLengthFriendly(difficulty, TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT)
							sm:SetMildLength(length)
						end
					end
				},
	["wet_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetWetLength(difficulty)
						else
							local length = GetSeasonLengthHarsh(difficulty, TUNING.SEASON_LENGTH_HARSH_DEFAULT)
							sm:SetWetLength(length)
						end
					end
				},
	["green_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetGreenLength(difficulty)
						else
							local length = GetSeasonLengthFriendly(difficulty, TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT)
							sm:SetGreenLength(length)
						end
					end
				},
	["dry_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetDryLength(difficulty)
						else
							local length = GetSeasonLengthHarsh(difficulty, TUNING.SEASON_LENGTH_HARSH_DEFAULT)
							sm:SetDryLength(length)
						end
					end
				},
	["temperate_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetTemperateLength(difficulty)
						else
							local length = GetSeasonLengthFriendly(difficulty, TUNING.PLATEAU_SEASON_LENGTH_DEFAULT)
							sm:SetTemperateLength(length)
						end
					end
				},
	["humid_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetHumidLength(difficulty)
						else
							local length = GetSeasonLengthFriendly(difficulty, TUNING.PLATEAU_SEASON_LENGTH_DEFAULT)
							sm:SetHumidLength(length)
						end
					end
				},
	["lush_season"] = {
					doit = function(difficulty)
						local sm = GetSeasonManager()
						if not sm then return end
						if type(difficulty) == "number" then
							sm:SetLushLength(difficulty)
						else
							local length = GetSeasonLengthFriendly(difficulty, TUNING.PLATEAU_SEASON_LENGTH_DEFAULT)
							sm:SetLushLength(length)
						end
					end
				},

	["season_mode"] = 	{
					doit = 	function(difficulty)
					
							if not GetSeasonManager() then
								return
							end
							
							if difficulty == "preonlywinter" then
								GetSeasonManager():EndlessWinter(10,10)
							elseif difficulty == "preonlyautumn" then
								GetSeasonManager():EndlessAutumn(10,10)
							elseif difficulty == "onlysummer" then
								GetSeasonManager():AlwaysSummer()
							elseif difficulty == "onlywinter" then
								GetSeasonManager():AlwaysWinter()
							elseif difficulty == "onlyspring" then
								GetSeasonManager():AlwaysSpring()
							elseif difficulty == "onlyautumn" then
								GetSeasonManager():AlwaysAutumn()
							elseif difficulty == "tropical" then
								GetSeasonManager():Tropical()
							elseif difficulty == "plateau" then
								GetSeasonManager():Plateau()								
							else
								local tuning_vars = {		 										
									["default"] = {autumn=true, winter=true, spring=true, summer=true},

									["classic"] = {autumn=true, winter=true, spring=false, summer=false},
									["dlc"] = 	 {autumn=false, winter=false, spring=true, summer=true},
									["extreme"] =  {autumn=false, winter=true, spring=false, summer=true},
									["static"] = 	{autumn=true, winter=false, spring=true, summer=false},

									["noautumn"] = 	{autumn=false, winter=true, spring=true, summer=true},
									["nowinter"] = 	{autumn=true, winter=false, spring=true, summer=true},
									["nospring"] = 	{autumn=true, winter=true, spring=false, summer=true},
									["nosummer"] = 	{autumn=true, winter=true, spring=true, summer=false},
								}
								GetSeasonManager():SetSeasonsEnabled(tuning_vars[difficulty].autumn, tuning_vars[difficulty].winter, tuning_vars[difficulty].spring, tuning_vars[difficulty].summer)
							end
							--print("SET SEASON ["..difficulty.."]")
						end
					},
	["season"] = 	{ --this is only called by the RAINY (A Cold Reception) adventure level. I left everything intact but changed code refs to summer to ref to autumn
					doit = 	function(difficulty)
					
							if not GetSeasonManager() then
								return
							end
							
							if difficulty == "preonlywinter" then
								GetSeasonManager():EndlessWinter(10,10)
							elseif difficulty == "preonlysummer" then
								GetSeasonManager():EndlessSpring(10,10)
							elseif difficulty == "onlysummer" then
								GetSeasonManager():AlwaysAutumn()
							elseif difficulty == "onlywinter" then
								GetSeasonManager():AlwaysWinter()
							else
								local tuning_vars = {												
									
									["longsummer"] = {autumn= 50 , winter= 10, start=50},
									["longwinter"] = {autumn= 10, winter= 50, start=10},
									
									["longboth"] = 	 {autumn= 50 , winter= 50, start=50},
									["shortboth"] =  {autumn= 10 , winter= 10, start=10},

									["autumn"] = 	{autumn= 5, winter= 3, start=5},
									["spring"] = 	{autumn= 3, winter= 5, start=3},
								}
								GetSeasonManager():SetSeasonLengths(tuning_vars[difficulty].autumn, tuning_vars[difficulty].winter)
							end
							--print("SET SEASON ["..difficulty.."]")
						end
					},
	["season_length"] = 	{
					doit = 	function(difficulty)
					
							if not GetSeasonManager() then
								return
							end
							
							local tuning_vars = {			
								["shortseasons"] = {autumn=15, winter=10, spring=15, summer=10}, 
								["default"] = {autumn=TUNING.AUTUMN_LENGTH, winter=TUNING.WINTER_LENGTH, spring=TUNING.SPRING_LENGTH, summer=TUNING.SUMMER_LENGTH}, 
								["longseasons"] = {autumn=25, winter= 20, spring=25, summer=20}, 
							}
							GetSeasonManager():SetSeasonLengths(tuning_vars[difficulty].autumn, tuning_vars[difficulty].winter, tuning_vars[difficulty].spring, tuning_vars[difficulty].summer)
							--print("SET SEASON ["..difficulty.."]")
						end
					},
	["season_start"] = 	{
					doit = 	function(data)

							if not GetSeasonManager() then
								return 
							end
							if data == "autumn" then
								GetSeasonManager():StartAutumn()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "summer" then
								GetSeasonManager():StartSummer()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "winter" then
								GetSeasonManager():StartWinter()
								GetSeasonManager().ground_snow_level = 1
							elseif data == "spring" then
								GetSeasonManager():StartSpring(true)
								GetSeasonManager().ground_snow_level = 0
							elseif data == "mild" then
								GetSeasonManager():StartMild()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "wet" then
								GetSeasonManager():StartWet()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "green" then
								GetSeasonManager():StartGreen()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "dry" then
								GetSeasonManager():StartDry()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "temperate" then
								GetSeasonManager():StartTemperate()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "humid" then
								GetSeasonManager():StartHumid()
								GetSeasonManager().ground_snow_level = 0
							elseif data == "lush" then
								GetSeasonManager():StartLush()
								GetSeasonManager().ground_snow_level = 0								
							elseif data == "random" then
								local rand = math.random(1,4)
								if rand == 1 then
									GetSeasonManager():StartSummer()
									GetSeasonManager().ground_snow_level = 0
								elseif rand == 2 then
									GetSeasonManager():StartWinter()
									GetSeasonManager().ground_snow_level = 1
								elseif rand == 3 then
									GetSeasonManager():StartAutumn()
									GetSeasonManager().ground_snow_level = 0
								else
									GetSeasonManager():StartSpring(true)
									GetSeasonManager().ground_snow_level = 0
								end
							end
						end
					},
	["weather"] = 	{
					doit = 	function(data)
							if not GetSeasonManager() then
								return
							end
					
							local tuning_vars = {	
												["default"] = function() end,											
												["never"] =  function() 
																		GetSeasonManager():AlwaysDry()
																		GetSeasonManager():StopPrecip()
																	 end,
												["rare"] = 	 function() 
																		GetSeasonManager():SetMoiustureMult(0.5)
																	 end,
												["often"] =  function() 
																		GetSeasonManager():SetMoiustureMult(2)
																	 end,
												["squall"] =  function() 
																		GetSeasonManager():SetMoiustureMult(30)
																	 end,
												["always"] = function() 
																		GetSeasonManager():AlwaysWet()
																	 end,
											}
							tuning_vars[data]()

						end
					},
	["frograin"] = {
					doit = 	function(difficulty)
						local tuning_vars = {
							["default"] =  {FROG_RAIN_CHANCE=.16, FROG_RAIN_LOCAL_MIN_EARLY = 7, FROG_RAIN_LOCAL_MAX_EARLY = 15, FROG_RAIN_LOCAL_MIN_LATE = 12, FROG_RAIN_LOCAL_MAX_LATE = 30},
							["never"] = {FROG_RAIN_CHANCE= -1, FROG_RAIN_LOCAL_MIN_EARLY = 0, FROG_RAIN_LOCAL_MAX_EARLY = 1, FROG_RAIN_LOCAL_MIN_LATE = 0, FROG_RAIN_LOCAL_MAX_LATE = 1},
							["rare"] =  {FROG_RAIN_CHANCE=.08, FROG_RAIN_LOCAL_MIN_EARLY = 3, FROG_RAIN_LOCAL_MAX_EARLY = 7, FROG_RAIN_LOCAL_MIN_LATE = 7, FROG_RAIN_LOCAL_MAX_LATE = 20},
							["often"] =  {FROG_RAIN_CHANCE=.33, FROG_RAIN_LOCAL_MIN_EARLY = 10, FROG_RAIN_LOCAL_MAX_EARLY = 23, FROG_RAIN_LOCAL_MIN_LATE = 15, FROG_RAIN_LOCAL_MAX_LATE = 40},
							["always"] =  {FROG_RAIN_CHANCE=.5, FROG_RAIN_LOCAL_MIN_EARLY = 10, FROG_RAIN_LOCAL_MAX_EARLY = 30, FROG_RAIN_LOCAL_MIN_LATE = 20, FROG_RAIN_LOCAL_MAX_LATE = 50},
							["force"] =  {FROG_RAIN_CHANCE=1, FROG_RAIN_LOCAL_MIN_EARLY = 10, FROG_RAIN_LOCAL_MAX_EARLY = 30, FROG_RAIN_LOCAL_MIN_LATE = 20, FROG_RAIN_LOCAL_MAX_LATE = 50},
						}
						OverrideTuningVariables(tuning_vars[difficulty])
					end
					},
	["wildfires"] = {
					doit = 	function(difficulty)
						local tuning_vars = {
							["never"] = {WILDFIRE_CHANCE = -1},
							["rare"] =  {WILDFIRE_CHANCE = .1},
							["default"] =  {WILDFIRE_CHANCE = .2},
							["often"] =  {WILDFIRE_CHANCE = .4},
							["always"] =  {WILDFIRE_CHANCE = .75},
						}
						OverrideTuningVariables(tuning_vars[difficulty])
					end
					},
	["lightning"] = 	{
					doit = 	function(data)
							if not GetSeasonManager() then return end
							
							local tuning_vars = {	
												["default"] = function() end,											
												["never"] =  function() 
																		GetSeasonManager():LightningNever()
																	 end,
												["rare"] = 	 function() 
																		GetSeasonManager():OverrideLightningDelays(60, 90)
																	 end,
												["often"] =  function() 
																		GetSeasonManager():LightningWhenPrecipitating()
																		GetSeasonManager():OverrideLightningDelays(10, 20)
																	 end,
												["always"] = function() 
																		GetSeasonManager():OverrideLightningDelays(10, 30)
																		GetSeasonManager():LightningAlways()
																	 end,
											}
							tuning_vars[data]()

						end
					},
	["creepyeyes"] = 	{
							doit = 	function(difficulty)
										local tuning_vars = {
												["always"] =
												{
													CREEPY_EYES = 
													{
														{maxsanity=1, maxeyes=6},
													},
												},
											}
										OverrideTuningVariables(tuning_vars[difficulty])
									end,
							},
	["areaambient"] = 	{
							doit = 	function(data)
										local ambient = GetWorld()
										-- HACK HACK HACK
										ambient.components.ambientsoundmixer:SetOverride(GROUND.ROAD, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.ROCKY, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.DIRT, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.WOODFLOOR, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.GRASS, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.SAVANNA, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.FOREST, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.MARSH, data)
										ambient.components.ambientsoundmixer:SetOverride(GROUND.IMPASSABLE, data)
										ambient.components.ambientsoundmixer:UpdateAmbientGeoMix()
									end,
						}, 
	["areaambientdefault"] = 	{
							doit = 	function(data)
										local ambient = GetWorld()

										if data== "cave" then
											-- Clear out the above ground (forest) sounds
											ambient.components.ambientsoundmixer:SetOverride(GROUND.ROAD, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.ROCKY, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.DIRT, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.WOODFLOOR, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.SAVANNA, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.GRASS, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.FOREST, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.CHECKER, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.MARSH, "SINKHOLE")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.IMPASSABLE, "ABYSS")
										else
											-- Clear out the cave sounds
											ambient.components.ambientsoundmixer:SetOverride(GROUND.CAVE, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.FUNGUSRED, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.FUNGUSGREEN, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.FUNGUS, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.SINKHOLE, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.UNDERROCK, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.MUD, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.UNDERGROUND, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.BRICK, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.BRICK_GLOW, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.TILES, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.TILES_GLOW, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.TRIM, "ROCKY")
											ambient.components.ambientsoundmixer:SetOverride(GROUND.TRIM_GLOW, "ROCKY")
										end

										ambient.components.ambientsoundmixer:UpdateAmbientGeoMix()
									end,
						}, 
	["volcano"] = 	{
							doit = 	function(data)
										if data == "never" then
											local vm = GetWorld().components.volcanomanager
											if vm then
												vm:SetIntensity(0)
											end
										end
									end,
						},
	["dragoonegg"] = 	{
							doit = 	function(difficulty)
										local vm = GetWorld().components.volcanomanager
										if vm then
											if difficulty == "never" then
												vm:SetFirerainIntensity(0.0)
											elseif difficulty == "rare" then
												vm:SetFirerainIntensity(0.5)
											elseif difficulty == "often" then
												vm:SetFirerainIntensity(1.5)
											elseif difficulty == "always" then
												vm:SetFirerainIntensity(2.0)
											end
										end
									end,
						},
	["tides"] = 	{
							doit = 	function(data)
										if data == "never" then
											local world = GetWorld()
											if world and world.components.flooding then
												world.components.flooding:SetMaxTideModifier(0)
											end
										end
									end,
						},
	["floods"] = 	{
							doit = 	function(difficulty)
										local flooding = GetWorld().components.flooding
										if flooding then
											local lvl = TUNING.MAX_FLOOD_LEVEL --15,
											local freq = TUNING.FLOOD_FREQUENCY --0.005,
											if difficulty == "never" then
												flooding:SetFloodSettings(0, 0)
											elseif difficulty == "rare" then
												flooding:SetFloodSettings(0.5 * lvl, 0.5 * freq)
											elseif difficulty == "often" then
												flooding:SetFloodSettings(lvl, 1.5 * freq)
											elseif difficulty == "always" then
												flooding:SetFloodSettings(lvl, 2.0 * freq)
											end
										end
									end,
						},
	["oceanwaves"] = 	{
							doit = 	function(difficulty)
										local wm = GetWorld().components.wavemanager
										if wm then
											if difficulty == "never" then
												wm:SetWaveSettings(0.0, 0.0, 0.0)
											elseif difficulty == "veryrare" then
												wm:SetWaveSettings(0.25, 0.25, 0.1)
											elseif difficulty == "rare" then
												wm:SetWaveSettings(0.5, 0.5, 0.5)
											elseif difficulty == "often" then
												wm:SetWaveSettings(1.25, 1.25, 1.0)
											elseif difficulty == "always" then
												wm:SetWaveSettings(1.5, 1.5, 1.0)
											end
										end
									end,
						},
	["poison"] = 		{
							doit = 	function(data)
										if data == "never" then
											local globalsettings = GetWorld().components.globalsettings
											if globalsettings then
												globalsettings.settings.poisondisabled = true
											end
										end
									end,
						},
	["waves"] = 		{
							doit = 	function(data)
										if data == "off" then
											local ground = GetWorld()
											if ground.WaveComponent then
												ground.WaveComponent:SetMultColour(0,0,0,0)
											end
										end
									end,
						}, 
	["ColourCube"] = 	{
							doit = 	function(data)
										local COLOURCUBE = "images/colour_cubes/"..data..".tex"
										GetWorld().components.colourcubemanager:SetOverrideColourCube(COLOURCUBE)
									end,
						}, 
	["fog"] = 			{
							doit = 	function(data)
								if data == "never" then
									local seasonmanger = GetWorld().components.seasonmanager
									if seasonmanger then
										seasonmanger.fogdisabled = true
									end
								end							
							end,
						},
	["brambles"] = 			{
							doit = 	function(data)
								if data == "never" then
									local bramblemanager = GetWorld().components.bramblemanager
									if bramblemanager then
										bramblemanager.disabled = true
									end
								end							
							end,
						},
	["glowflycycle"] = {
							doit = 	function(data)					
								if data == "never" then
									local glowflyspawner = GetWorld().components.glowflyspawner
									if glowflyspawner then
										glowflyspawner.nocycle = true
									end
								end							
							end,
						},						
	["glowfly"] = 		{
							doit = 	function(difficulty)
								local glowflies = GetWorld().components.glowflyspawner
								if glowflies then
									glowflies:SpawnModeHeavy()
									if difficulty == "never" then
										glowflies:SpawnModeNever()
									elseif difficulty == "always" then
										glowflies:SpawnModeHeavy()
									elseif difficulty == "often" then
										glowflies:SpawnModeMed()
									elseif difficulty == "rare" then
										glowflies:SpawnModeLight()
									end
								end								
							end,
						},		
	["vampirebat"] = 	{
							doit = 	function(difficulty)
								local batted = GetWorld().components.batted
								if batted then									
									if difficulty == "never" then -- 0
										batted:Disable(true)
									elseif difficulty == "always" then --4
										batted:SetDiffMod(0.75)
									elseif difficulty == "often" then --3
										batted:SetDiffMod(0.9)
									elseif difficulty == "rare" then -- 1 
										batted:SetDiffMod(1.25)
									end
								end								
							end,
						},
	["vampirebatcave"] ={
							doit = 	function(difficulty)
								local batted = GetWorld().components.batted
								if batted then									
									if difficulty == "never" then -- 0
										batted:Disable(true)
									end
								end								
							end,
						},		

	["weevole"] = 		{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.WEEVOLEDEN_MAX_WEEVOLES = TUNING.WEEVOLEDEN_MAX_WEEVOLES * 0
								elseif difficulty == "always" then --4
									TUNING.WEEVOLEDEN_MAX_WEEVOLES = TUNING.WEEVOLEDEN_MAX_WEEVOLES + 3
								elseif difficulty == "often" then --3
									TUNING.WEEVOLEDEN_MAX_WEEVOLES = TUNING.WEEVOLEDEN_MAX_WEEVOLES + 1
								elseif difficulty == "rare" then -- 1 
									TUNING.WEEVOLEDEN_MAX_WEEVOLES = TUNING.WEEVOLEDEN_MAX_WEEVOLES -1
								end
							end,
						},
	["gnat"] = 			{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.GNATMOUND_MAX_CHILDREN = TUNING.GNATMOUND_MAX_CHILDREN * 0
								elseif difficulty == "always" then --4
									TUNING.GNATMOUND_MAX_CHILDREN = TUNING.GNATMOUND_MAX_CHILDREN + 3
								elseif difficulty == "often" then --3
									TUNING.GNATMOUND_MAX_CHILDREN = TUNING.GNATMOUND_MAX_CHILDREN + 1
								elseif difficulty == "rare" then -- 1 
									TUNING.GNATMOUND_REGEN_TIME = TUNING.GNATMOUND_REGEN_TIME * 2
								end
							end,
						},		
	["bill"] = 			{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.BILL_SPAWN_CHANCE = TUNING.BILL_SPAWN_CHANCE * 0
								elseif difficulty == "always" then --4
									TUNING.BILL_SPAWN_CHANCE = TUNING.BILL_SPAWN_CHANCE * 2
								elseif difficulty == "often" then --3
									TUNING.BILL_SPAWN_CHANCE = TUNING.BILL_SPAWN_CHANCE * 1.5
								elseif difficulty == "rare" then -- 1 
									TUNING.BILL_SPAWN_CHANCE = TUNING.BILL_SPAWN_CHANCE * 0.5
								end
							end,
						},
	["frog_poison"] = 	{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.FROG_POISON_MAX_SPAWN = TUNING.FROG_POISON_MAX_SPAWN * 0
								elseif difficulty == "always" then --4
									TUNING.FROG_POISON_MAX_SPAWN = TUNING.FROG_POISON_MAX_SPAWN + 3
								elseif difficulty == "often" then --3
									TUNING.FROG_POISON_MAX_SPAWN = TUNING.FROG_POISON_MAX_SPAWN + 1
								elseif difficulty == "rare" then -- 1 
									TUNING.FROG_POISON_REGEN_TIME = TUNING.FROG_POISON_REGEN_TIME * 2
								end
							end,
						},
	["mosquito"] = 		{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.MOSQUITO_MAX_SPAWN = TUNING.MOSQUITO_MAX_SPAWN * 0
								elseif difficulty == "always" then --4
									TUNING.MOSQUITO_MAX_SPAWN = TUNING.MOSQUITO_MAX_SPAWN + 3
								elseif difficulty == "often" then --3
									TUNING.MOSQUITO_MAX_SPAWN = TUNING.MOSQUITO_MAX_SPAWN + 1
								elseif difficulty == "rare" then -- 1 
									TUNING.MOSQUITO_REGEN_TIME = TUNING.MOSQUITO_REGEN_TIME * 2
								end
							end,
						},
	["antman"] = 		{
							doit = 	function(difficulty)							
								if difficulty == "never" then -- 0
									TUNING.ANTMAN_MIN = TUNING.ANTMAN_MIN * 0
									TUNING.ANTMAN_MAX = TUNING.ANTMAN_MAX * 0									
								elseif difficulty == "always" then --4
									TUNING.ANTMAN_MIN = TUNING.ANTMAN_MIN + 3
									TUNING.ANTMAN_MAX = TUNING.ANTMAN_MAX + 3									
								elseif difficulty == "often" then --3
									TUNING.ANTMAN_MIN = TUNING.ANTMAN_MIN + 1
									TUNING.ANTMAN_MAX = TUNING.ANTMAN_MAX + 1									
								elseif difficulty == "rare" then -- 1 
									TUNING.ANTMAN_MIN = math.max(0,TUNING.ANTMAN_MIN -1)
									TUNING.ANTMAN_MAX = math.max(0,TUNING.ANTMAN_MAX -1)
								end
							end,
						},	
	["pigbandit"] = 		{
							doit = 	function(difficulty)							
								local banditmanager = GetWorld().components.banditmanager
								if banditmanager then
									if difficulty == "never" then -- 0
										banditmanager.disabled = true
									elseif difficulty == "always" then --4
										banditmanager:SetDiffMod(2.5)
									elseif difficulty == "often" then --3
										banditmanager:SetDiffMod(1.5)
									elseif difficulty == "rare" then -- 1 
										banditmanager:SetDiffMod(0.5)
									end
								end
							end,
						},	
	["giantgrub"] = 		{
							doit = 	function(difficulty)							
								local giantgrubspawner = GetWorld().components.giantgrubspawner
								if giantgrubspawner then
									if difficulty == "never" then -- 0
										giantgrubspawner.disabled = true
									elseif difficulty == "always" then --4
										giantgrubspawner:SetDiffMod(3)
									elseif difficulty == "often" then --3
										giantgrubspawner:SetDiffMod(2)
									elseif difficulty == "rare" then -- 1 
										giantgrubspawner:SetDiffMod(0.5)
									end
								end
							end,
						},
	["roc"] = 		{
							doit = 	function(difficulty)							
								local rocmanager = GetWorld().components.rocmanager
								if rocmanager then
									if difficulty == "never" then -- 0
										rocmanager.disabled = true
									end
								end
							end,
						},
	["hanging_vine"] = 	{
		doit = 	function(difficulty)
			local tuning_vars = {
					["never"] =  {HANGING_VINE_SPAWN_MIN = 0, HANGING_VINE_SPAWN_MAX = 0},
					["rare"]  =  {HANGING_VINE_SPAWN_MIN = TUNING.HANGING_VINE_SPAWN_MIN * 0.5, HANGING_VINE_SPAWN_MAX = TUNING.HANGING_VINE_SPAWN_MAX * 0.5},
					["often"] =  {HANGING_VINE_SPAWN_MIN = TUNING.HANGING_VINE_SPAWN_MIN * 1.5, HANGING_VINE_SPAWN_MAX = TUNING.HANGING_VINE_SPAWN_MAX * 1.5},
					["always"] = {HANGING_VINE_SPAWN_MIN = TUNING.HANGING_VINE_SPAWN_MIN * 3,   HANGING_VINE_SPAWN_MAX = TUNING.HANGING_VINE_SPAWN_MAX * 3  },
				}
			OverrideTuningVariables(tuning_vars[difficulty])
		end,
	},
	["grabbing_vine"] = 	{
		doit = 	function(difficulty)
			local tuning_vars = {
					["never"] =  {GRABBING_VINE_SPAWN_MIN = 0, GRABBING_VINE_SPAWN_MAX = 0},
					["rare"]  =  {GRABBING_VINE_SPAWN_MIN = TUNING.GRABBING_VINE_SPAWN_MIN * 0.5, GRABBING_VINE_SPAWN_MAX = TUNING.GRABBING_VINE_SPAWN_MAX * 0.5},
					["often"] =  {GRABBING_VINE_SPAWN_MIN = TUNING.GRABBING_VINE_SPAWN_MIN * 1.5, GRABBING_VINE_SPAWN_MAX = TUNING.GRABBING_VINE_SPAWN_MAX * 1.5},
					["always"] = {GRABBING_VINE_SPAWN_MIN = TUNING.GRABBING_VINE_SPAWN_MIN * 3,   GRABBING_VINE_SPAWN_MAX = TUNING.GRABBING_VINE_SPAWN_MAX * 3  },
				}
			OverrideTuningVariables(tuning_vars[difficulty])
		end,
	},
}

return {OVERRIDES = TUNING_OVERRIDES}
