require "recipe"
require "tuning"

--Note: If you want to add a new tech tree you must also add it into the "TECH" constant in constants.lua

--LIGHT
Recipe("campfire", {Ingredient("cutgrass", 3),Ingredient("log", 2)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.COMMON, "campfire_placer")
Recipe("firepit", {Ingredient("log", 2),Ingredient("rocks", 12)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.COMMON, "firepit_placer")
Recipe("chiminea", {Ingredient("limestone", 2), Ingredient("sand", 2), Ingredient("log", 2)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "chiminea_placer")
Recipe("torch", {Ingredient("cutgrass", 2),Ingredient("twigs", 2)}, RECIPETABS.LIGHT, TECH.NONE)
Recipe("tarlamp", {Ingredient("seashell", 1), Ingredient("tar", 1)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("coldfire", {Ingredient("cutgrass", 3), Ingredient("nitre", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "coldfire_placer")
Recipe("coldfirepit", {Ingredient("nitre", 2), Ingredient("cutstone", 4), Ingredient("transistor", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "coldfirepit_placer")
Recipe("obsidianfirepit", {Ingredient("log", 3),Ingredient("obsidian", 8)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "obsidianfirepit_placer")


Recipe("minerhat", {Ingredient("strawhat", 1),Ingredient("goldnugget", 1),Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO)
Recipe("bottlelantern", {Ingredient("messagebottleempty", 1), Ingredient("bioluminescence", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boat_torch", {Ingredient("twigs", 2), Ingredient("torch", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boat_lantern", {Ingredient("messagebottleempty", 1), Ingredient("twigs", 2), Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("sea_chiminea", {Ingredient("sand", 4), Ingredient("tar", 6), Ingredient("limestone", 6)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "sea_chiminea_placer", nil, nil, nil, true)

-- ROG
Recipe("molehat", {Ingredient("mole", 2), Ingredient("transistor", 2), Ingredient("wormlight", 1)}, RECIPETABS.LIGHT,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("pumpkin_lantern", {Ingredient("pumpkin", 1), Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("lantern", {Ingredient("twigs", 3), Ingredient("rope", 2), Ingredient("lightbulb", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)

--STRUCTURES
Recipe("treasurechest", {Ingredient("boards", 3)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "treasurechest_placer",1)
Recipe("waterchest", {Ingredient("tar", 1), Ingredient("boards", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "waterchest_placer", 1, nil, nil, true)
Recipe("homesign", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "homesign_placer")
Recipe("minisign_item", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, nil, nil, nil, nil, 4)

Recipe("fence_gate_item", {Ingredient("boards", 2), Ingredient("rope", 1) }, RECIPETABS.TOWN, TECH.SCIENCE_TWO,nil,nil,nil,nil,1)
Recipe("fence_item", {Ingredient("twigs", 3), Ingredient("rope", 1) }, RECIPETABS.TOWN, TECH.SCIENCE_ONE, nil,nil,nil,nil,6)

Recipe("wall_hay_item", {Ingredient("cutgrass", 4), Ingredient("twigs", 2) }, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, nil,nil,nil,4)
Recipe("wall_wood_item", {Ingredient("boards", 2),Ingredient("rope", 1)}, RECIPETABS.TOWN,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, nil,nil,nil,8)
Recipe("wall_stone_item", {Ingredient("cutstone", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, nil,nil,nil,6)
Recipe("wall_limestone_item", {Ingredient("limestone", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil,nil,nil,6)
Recipe("wall_enforcedlimestone_item", {Ingredient("limestone", 2), Ingredient("seaweed", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil,nil,nil,6)
Recipe("pighouse", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA, "pighouse_placer")
Recipe("wildborehouse", {Ingredient("bamboo", 8), Ingredient("palmleaf", 5), Ingredient("pigskin", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "wildborehouse_placer")
--Recipe("monkeybarrel", {Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "monkeybarrel_placer")
Recipe("ballphinhouse", {Ingredient("limestone", 4), Ingredient("seaweed", 4), Ingredient("dorsalfin", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "ballphinhouse_placer", 100, nil, nil, true)
Recipe("primeapebarrel", {Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "primeapebarrel_placer")
Recipe("dragoonden", {Ingredient("dragoonheart", 1), Ingredient("rocks", 5), Ingredient("obsidian", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "dragoonden_placer")
Recipe("rabbithouse", {Ingredient("boards", 4), Ingredient("carrot", 10), Ingredient("manrabbit_tail", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA, "rabbithouse_placer")
Recipe("birdcage", {Ingredient("papyrus", 2), Ingredient("goldnugget", 6), Ingredient("seeds", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "birdcage_placer")

Recipe("turf_road", {Ingredient("turf_rocky", 1), Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("turf_road", {Ingredient("turf_magmafield", 1), Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("turf_woodfloor", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO)
Recipe("turf_checkerfloor", {Ingredient("marble", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("turf_carpetfloor", {Ingredient("boards", 1), Ingredient("beefalowool", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("turf_snakeskinfloor", {Ingredient("snakeskin", 2), Ingredient("fabric", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("pottedfern", {Ingredient("foliage", 2), Ingredient("slurtle_shellpieces",1 )}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA, "pottedfern_placer", 0.9)
Recipe("sandbagsmall_item", {Ingredient("fabric", 2), Ingredient("sand", 3)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil,nil,nil,4)
Recipe("sand_castle", {Ingredient("sand", 4), Ingredient("palmleaf", 2), Ingredient("seashell", 3)}, RECIPETABS.TOWN,  TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "sandcastle_placer")
Recipe("dragonflychest", {Ingredient("dragon_scales", 1), Ingredient("boards", 4), Ingredient("goldnugget", 10)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG, "dragonflychest_placer", 1.5)

--FARM
Recipe("mussel_stick", {Ingredient("bamboo", 2), Ingredient("vine", 1), Ingredient("seaweed", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("slow_farmplot", {Ingredient("cutgrass", 8),Ingredient("poop", 4),Ingredient("log", 4)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "slow_farmplot_placer")
Recipe("fast_farmplot", {Ingredient("cutgrass", 10),Ingredient("poop", 6),Ingredient("rocks", 4)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "fast_farmplot_placer")
Recipe("fertilizer", {Ingredient("poop",3), Ingredient("boneshard", 2), Ingredient("log", 4)}, RECIPETABS.FARM, TECH.SCIENCE_TWO)
Recipe("beebox", {Ingredient("boards", 2),Ingredient("honeycomb", 1),Ingredient("bee", 4)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "beebox_placer")
Recipe("meatrack", {Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "meatrack_placer")
Recipe("cookpot", {Ingredient("cutstone", 3),Ingredient("charcoal", 6), Ingredient("twigs", 6)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "cookpot_placer")
Recipe("icebox", {Ingredient("goldnugget", 2), Ingredient("gears", 1), Ingredient("cutstone", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "icebox_placer", 1.5)
Recipe("fish_farm", {Ingredient("coconut", 4),Ingredient("rope", 2),Ingredient("silk", 2)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "fish_farm_placer", nil, nil, nil, true)
Recipe("mussel_bed", {Ingredient("mussel", 1),Ingredient("coral", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)


--SURVIVAL
Recipe("trap", {Ingredient("twigs", 2),Ingredient("cutgrass", 6)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("birdtrap", {Ingredient("twigs", 3),Ingredient("silk", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("bugnet", {Ingredient("twigs", 4), Ingredient("silk", 2), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("bundlewrap", {Ingredient("waxpaper", 1), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.LOST, RECIPE_GAME_TYPE.COMMON)
Recipe("fishingrod", {Ingredient("twigs", 2),Ingredient("silk", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("monkeyball", {Ingredient("snakeskin", 2), Ingredient("cave_banana", 1), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
--Recipe("bigfishingrod", {Ingredient("twigs", 2),Ingredient("silk", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("grass_umbrella", {Ingredient("twigs", 4) ,Ingredient("cutgrass", 3), Ingredient("petals", 6)}, RECIPETABS.SURVIVAL, TECH.NONE, RECIPE_GAME_TYPE.ROG)
Recipe("palmleaf_umbrella", {Ingredient("twigs", 4) ,Ingredient("palmleaf", 3), Ingredient("petals", 6)}, RECIPETABS.SURVIVAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("umbrella", {Ingredient("twigs", 6) ,Ingredient("pigskin", 1), Ingredient("silk",2 )}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("bandage", {Ingredient("papyrus", 1), Ingredient("honey", 2)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
Recipe("healingsalve", {Ingredient("ash", 2), Ingredient("rocks", 1), Ingredient("spidergland",1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("antivenom", {Ingredient("venomgland", 1), Ingredient("seaweed", 3), Ingredient("coral", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("compass", {Ingredient("goldnugget", 1), Ingredient("papyrus", 1)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE)
Recipe("heatrock", {Ingredient("rocks", 10),Ingredient("pickaxe", 1),Ingredient("flint", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO)

Recipe("thatchpack", {Ingredient("palmleaf", 4)}, RECIPETABS.SURVIVAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("backpack", {Ingredient("cutgrass", 4), Ingredient("twigs", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("piggyback", {Ingredient("pigskin", 4), Ingredient("silk", 6), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO)
Recipe("bedroll_straw", {Ingredient("cutgrass", 6), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
Recipe("bedroll_furry", {Ingredient("bedroll_straw", 1), Ingredient("manrabbit_tail", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("tent", {Ingredient("silk", 6),Ingredient("twigs", 4),Ingredient("rope", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "tent_placer")
Recipe("siestahut", {Ingredient("silk", 2),Ingredient("boards", 4),Ingredient("rope", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "siestahut_placer")
Recipe("palmleaf_hut", {Ingredient("palmleaf", 4),Ingredient("bamboo", 4),Ingredient("rope", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "palmleaf_hut_placer")
Recipe("featherfan", {Ingredient("goose_feather", 5), Ingredient("cutreeds", 2), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("tropicalfan", {Ingredient("doydoyfeather", 5), Ingredient("cutreeds", 2), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("icepack", {Ingredient("bearger_fur", 1), Ingredient("gears", 1), Ingredient("transistor", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("seasack", {Ingredient("seaweed", 5), Ingredient("vine", 2), Ingredient("shark_gills", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("doydoynest", {Ingredient("twigs", 8), Ingredient("doydoyfeather", 2), Ingredient("poop", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "doydoynest_placer")


--TOOLS
Recipe("axe", {Ingredient("twigs", 1),Ingredient("flint", 1)}, RECIPETABS.TOOLS, TECH.NONE)
Recipe("goldenaxe", {Ingredient("twigs", 4),Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO)


Recipe("machete", {Ingredient("twigs", 1),Ingredient("flint", 3)}, RECIPETABS.TOOLS, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("goldenmachete", {Ingredient("twigs", 4),Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("pickaxe", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS, TECH.NONE)
Recipe("goldenpickaxe", {Ingredient("twigs", 4),Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO)

Recipe("shovel", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_ONE)
Recipe("goldenshovel", {Ingredient("twigs", 4),Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO)

Recipe("hammer", {Ingredient("twigs", 3),Ingredient("rocks", 3), Ingredient("cutgrass", 6)}, RECIPETABS.TOOLS, TECH.NONE)
Recipe("pitchfork", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_ONE)
Recipe("razor", {Ingredient("twigs", 2), Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_ONE)
Recipe("featherpencil", {Ingredient("twigs", 1), Ingredient("charcoal", 1), Ingredient("feather_crow", 1)}, RECIPETABS.TOOLS,  TECH.SCIENCE_ONE)

Recipe("saddlehorn", {Ingredient("twigs", 2), Ingredient("boneshard", 2), Ingredient("feather_crow", 1)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("saddle_basic", {Ingredient("beefalowool", 4), Ingredient("pigskin", 4), Ingredient("goldnugget", 4)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("saddle_war", {Ingredient("rabbit", 4), Ingredient("steelwool", 4), Ingredient("log", 10)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA) 
Recipe("saddle_race", {Ingredient("livinglog", 2), Ingredient("silk", 4), Ingredient("butterflywings", 68)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("brush", {Ingredient("walrus_tusk", 1), Ingredient("steelwool", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA) 
Recipe("saltlick", {Ingredient("boards", 2), Ingredient("nitre", 4)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA, "saltlick_placer")

--SCIENCE
Recipe("researchlab", {Ingredient("goldnugget", 1),Ingredient("log", 4),Ingredient("rocks", 4)}, RECIPETABS.SCIENCE, TECH.NONE, RECIPE_GAME_TYPE.COMMON, "researchlab_placer")
Recipe("researchlab2", {Ingredient("boards", 4),Ingredient("cutstone", 2), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "researchlab2_placer")
Recipe("researchlab5", {Ingredient("limestone", 4),Ingredient("sand", 2), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "researchlab5_placer", nil, nil, nil, true)
Recipe("transistor", {Ingredient("goldnugget", 2), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE, TECH.SCIENCE_ONE)
Recipe("diviningrod", {Ingredient("twigs", 1), Ingredient("nightmarefuel", 4), Ingredient("gears", 1)}, RECIPETABS.SCIENCE, TECH.SCIENCE_TWO)
Recipe("winterometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "winterometer_placer")
Recipe("rainometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2), Ingredient("rope",2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "rainometer_placer")
Recipe("gunpowder", {Ingredient("rottenegg", 1), Ingredient("charcoal", 1), Ingredient("nitre", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO)
Recipe("lightning_rod", {Ingredient("goldnugget", 4), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.COMMON, "lightning_rod_placer")
Recipe("firesuppressor", {Ingredient("gears", 2),Ingredient("ice", 15),Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "firesuppressor_placer")
Recipe("icemaker", {Ingredient("heatrock", 1),Ingredient("bamboo", 5), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "icemaker_placer")
Recipe("quackendrill", {Ingredient("quackenbeak", 1),Ingredient("gears", 1), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)


--MAGIC
Recipe("piratihatitator", {Ingredient("parrot", 1), Ingredient("boards", 4), Ingredient("piratehat", 1)}, RECIPETABS.MAGIC, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "piratihatitator_placer")
Recipe("researchlab4", {Ingredient("rabbit", 4), Ingredient("boards", 4), Ingredient("tophat", 1)}, RECIPETABS.MAGIC, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.VANILLA, "researchlab4_placer")
Recipe("researchlab3", {Ingredient("livinglog", 3), Ingredient("purplegem", 1), Ingredient("nightmarefuel", 7)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, RECIPE_GAME_TYPE.COMMON, "researchlab3_placer")
Recipe("resurrectionstatue", {Ingredient("boards", 4),Ingredient("cookedmeat", 4),Ingredient("beardhair", 4)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO, RECIPE_GAME_TYPE.COMMON, "resurrectionstatue_placer")
Recipe("panflute", {Ingredient("cutreeds", 5), Ingredient("mandrake", 1), Ingredient("rope", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO)
Recipe("ox_flute", {Ingredient("ox_horn", 1), Ingredient("nightmarefuel", 2), Ingredient("rope", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("bell", {Ingredient("glommerwings", 1), Ingredient("glommerflower", 1)}, RECIPETABS.MAGIC,  TECH.LOST, RECIPE_GAME_TYPE.ROG)
Recipe("onemanband", {Ingredient("goldnugget", 2),Ingredient("nightmarefuel", 4),Ingredient("pigskin", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO)
Recipe("nightlight", {Ingredient("goldnugget", 8), Ingredient("nightmarefuel", 2),Ingredient("redgem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO, RECIPE_GAME_TYPE.COMMON, "nightlight_placer")
Recipe("armor_sanity", {Ingredient("nightmarefuel", 5),Ingredient("papyrus", 3)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE)
Recipe("nightsword", {Ingredient("nightmarefuel", 5),Ingredient("livinglog", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE)
Recipe("batbat", {Ingredient("batwing", 3), Ingredient("livinglog", 2), Ingredient("purplegem", 1)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE, RECIPE_GAME_TYPE.VANILLA)
Recipe("armorslurper", {Ingredient("slurper_pelt", 6),Ingredient("rope", 2),Ingredient("nightmarefuel", 2)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE, RECIPE_GAME_TYPE.VANILLA)

Recipe("amulet", {Ingredient("goldnugget", 3), Ingredient("nightmarefuel", 2),Ingredient("redgem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO)
Recipe("blueamulet", {Ingredient("goldnugget", 3), Ingredient("bluegem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO)
Recipe("purpleamulet", {Ingredient("goldnugget", 6), Ingredient("nightmarefuel", 4),Ingredient("purplegem", 2)}, RECIPETABS.MAGIC,  TECH.MAGIC_THREE)
Recipe("firestaff", {Ingredient("nightmarefuel", 2), Ingredient("spear", 1), Ingredient("redgem", 1)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE)
Recipe("icestaff", {Ingredient("spear", 1),Ingredient("bluegem", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO)
Recipe("telestaff", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("purplegem", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE, nil)
Recipe("telebase", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 4), Ingredient("goldnugget", 8)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE, nil, "telebase_placer")
Recipe("shipwrecked_entrance", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 4), Ingredient("sunken_boat_trinket_4", 1)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE, {RECIPE_GAME_TYPE.VANILLA,RECIPE_GAME_TYPE.ROG,RECIPE_GAME_TYPE.SHIPWRECKED}, "shipwrecked_entrance_placer")
-- This is here so that the exit in the world can be hammered for goods.
Recipe("shipwrecked_exit", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 4), Ingredient("sunken_boat_trinket_4", 1)}, nil, TECH.LOST, RECIPE_GAME_TYPE.SHIPWRECKED, "shipwrecked_entrance_placer")

--REFINE
Recipe("rope", {Ingredient("cutgrass", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("boards", {Ingredient("log", 4)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("cutstone", {Ingredient("rocks", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("papyrus", {Ingredient("cutreeds", 4)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("fabric", {Ingredient("bamboo", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("limestone", {Ingredient("coral", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("nubbin", {Ingredient("limestone", 3), Ingredient("corallarve", 1)}, RECIPETABS.REFINE, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("goldnugget", {Ingredient("dubloon", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE)
Recipe("ice", {Ingredient("hail_ice", 4)}, RECIPETABS.REFINE, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("messagebottleempty", {Ingredient("sand", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("nightmarefuel", {Ingredient("petals_evil", 4)}, RECIPETABS.REFINE, TECH.MAGIC_TWO)
Recipe("purplegem", {Ingredient("redgem",1), Ingredient("bluegem", 1)}, RECIPETABS.REFINE, TECH.MAGIC_TWO)

Recipe("beeswax", {Ingredient("honeycomb", 1)}, RECIPETABS.REFINE, TECH.SCIENCE_ONE)
Recipe("waxpaper", {Ingredient("beeswax", 1), Ingredient("papyrus", 1)}, RECIPETABS.REFINE, TECH.SCIENCE_ONE)

--WAR
Recipe("spear", {Ingredient("twigs", 2),Ingredient("rope", 1),Ingredient("flint", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("spear_poison", {Ingredient("spear", 1), Ingredient("venomgland", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("hambat", {Ingredient("pigskin", 1), Ingredient("twigs", 2), Ingredient("meat", 2)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO)
Recipe("nightstick", {Ingredient("lightninggoathorn", 1), Ingredient("transistor", 2), Ingredient("nitre", 2)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("armorgrass", {Ingredient("cutgrass", 10), Ingredient("twigs", 2)}, RECIPETABS.WAR,  TECH.NONE, RECIPE_GAME_TYPE.VANILLA)
Recipe("armorwood", {Ingredient("log", 8),Ingredient("rope", 2)}, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("armorseashell", {Ingredient("seashell", 10),Ingredient("seaweed", 2),Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armormarble", {Ingredient("marble", 6),Ingredient("rope", 2)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("armorlimestone", {Ingredient("limestone", 3), Ingredient("rope", 2)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armorcactus", {Ingredient("needlespear", 3), Ingredient("armorwood", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("footballhat", {Ingredient("pigskin", 1), Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO)
Recipe("oxhat", {Ingredient("ox_horn", 1), Ingredient("seashell", 4), Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("blowdart_pipe", {Ingredient("cutreeds", 2),Ingredient("houndstooth", 1),Ingredient("feather_robin_winter", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("blowdart_sleep", {Ingredient("cutreeds", 2),Ingredient("stinger", 1),Ingredient("feather_crow", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("blowdart_fire", {Ingredient("cutreeds", 2),Ingredient("charcoal", 1),Ingredient("feather_robin", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("blowdart_poison", {Ingredient("cutreeds", 2),Ingredient("venomgland", 1),Ingredient("feather_crow", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boomerang", {Ingredient("boards", 1),Ingredient("silk", 1),Ingredient("charcoal", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO)
Recipe("beemine", {Ingredient("boards", 1),Ingredient("bee", 4),Ingredient("flint", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE)
Recipe("trap_teeth", {Ingredient("log", 1),Ingredient("rope", 1),Ingredient("houndstooth", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO)
Recipe("coconade", {Ingredient("coconut", 1), Ingredient("gunpowder", 1), Ingredient("rope", 1)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("spear_launcher", {Ingredient("bamboo", 3), Ingredient("jellyfish", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
-- Recipe("speargun", {Ingredient("seashell", 1), Ingredient("bamboo", 3),  Ingredient("jellyfish", 1)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
-- Recipe("speargun_poison", {Ingredient("seashell", 3), Ingredient("bamboo", 1),  Ingredient("venomgland", 1)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("cutlass", {Ingredient("dead_swordfish", 1), Ingredient("goldnugget", 2), Ingredient("twigs", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armordragonfly", {Ingredient("dragon_scales", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 3)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("staff_tornado", {Ingredient("goose_feather", 10), Ingredient("lightninggoathorn", 1), Ingredient("gears", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)

--DRESSUP

Recipe("sewing_kit", {Ingredient("log", 1), Ingredient("silk", 8), Ingredient("houndstooth", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO)
Recipe("flowerhat", {Ingredient("petals", 12)}, RECIPETABS.DRESS, TECH.NONE)
Recipe("strawhat", {Ingredient("cutgrass", 12)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("tophat", {Ingredient("silk", 6)}, RECIPETABS.DRESS,  TECH.SCIENCE_ONE)
Recipe("rainhat", {Ingredient("mole", 2), Ingredient("strawhat", 1), Ingredient("boneshard", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG, nil, nil, nil, nil, true)

Recipe("earmuffshat", {Ingredient("rabbit", 2), Ingredient("twigs",1)}, RECIPETABS.DRESS, TECH.NONE, RECIPE_GAME_TYPE.VANILLA)
Recipe("beefalohat", {Ingredient("beefalowool", 8),Ingredient("horn", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.VANILLA)
Recipe("winterhat", {Ingredient("beefalowool", 4),Ingredient("silk", 4)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("catcoonhat", {Ingredient("coontail", 1), Ingredient("silk", 4)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)

-- Recipe("eurekahat", {Ingredient("coral_brain", 1), Ingredient("transistor", 2), Ingredient("sand", 6)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("brainjellyhat", {Ingredient("coral_brain", 1), Ingredient("jellyfish", 1), Ingredient("rope", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("watermelonhat", {Ingredient("watermelon", 1), Ingredient("twigs", 3)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE)
Recipe("shark_teethhat", {Ingredient("houndstooth", 5), Ingredient("goldnugget", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("icehat", {Ingredient("transistor", 2), Ingredient("rope", 4), Ingredient("ice", 10)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO)
Recipe("beehat", {Ingredient("silk", 8), Ingredient("rope", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO)
Recipe("featherhat", {Ingredient("feather_crow", 3),Ingredient("feather_robin", 2), Ingredient("tentaclespots", 2)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO)
Recipe("bushhat", {Ingredient("strawhat", 1),Ingredient("rope", 1),Ingredient("dug_berrybush", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO)
Recipe("snakeskinhat", {Ingredient("snakeskin", 1), Ingredient("strawhat", 1), Ingredient("boneshard", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("raincoat", {Ingredient("tentaclespots", 2), Ingredient("rope", 2), Ingredient("boneshard", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.ROG, nil, nil, nil, nil, true)
Recipe("armor_snakeskin", {Ingredient("snakeskin", 2), Ingredient("vine", 2), Ingredient("boneshard", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("blubbersuit", {Ingredient("blubber", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("tarsuit", {Ingredient("tar", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("sweatervest", {Ingredient("houndstooth", 8),Ingredient("silk", 6)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("trunkvest_summer", {Ingredient("trunk_summer", 1),Ingredient("silk", 8)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("trunkvest_winter", {Ingredient("trunk_winter", 1),Ingredient("silk", 8), Ingredient("beefalowool", 2)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("reflectivevest", {Ingredient("rope", 1), Ingredient("feather_robin", 3), Ingredient("pigskin", 2)}, RECIPETABS.DRESS,  TECH.SCIENCE_ONE)
Recipe("hawaiianshirt", {Ingredient("papyrus", 3), Ingredient("silk", 3), Ingredient("petals", 5)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("hawaiianshirt", {Ingredient("papyrus", 3), Ingredient("silk", 3), Ingredient("cactus_flower", 5)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("cane", {Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA)
Recipe("beargervest", {Ingredient("bearger_fur", 1), Ingredient("sweatervest", 1), Ingredient("rope", 2)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("eyebrellahat", {Ingredient("deerclops_eyeball", 1), Ingredient("twigs", 15), Ingredient("boneshard", 4)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG)
Recipe("double_umbrellahat", {Ingredient("shark_gills", 2), Ingredient("umbrella", 1), Ingredient("strawhat", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armor_windbreaker", {Ingredient("blubber", 2), Ingredient("fabric", 1), Ingredient("rope", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED) -- CHECK  THIS
Recipe("gashat", {Ingredient("messagebottleempty", 2), Ingredient("coral", 3), Ingredient("jellyfish", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("aerodynamichat", {Ingredient("shark_fin", 1), Ingredient("vine", 2), Ingredient("coconut", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
----GEMS----

----ANCIENT----
Recipe("thulecite", {Ingredient("thulecite_pieces", 6)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)

Recipe("wall_ruins_item", {Ingredient("thulecite", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true, 6)

Recipe("nightmare_timepiece", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)

Recipe("orangeamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3),Ingredient("orangegem", 1)}, RECIPETABS.ANCIENT,  TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("yellowamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3),Ingredient("yellowgem", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("greenamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3),Ingredient("greengem", 1)}, RECIPETABS.ANCIENT,  TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)

Recipe("orangestaff", {Ingredient("nightmarefuel", 2), Ingredient("cane", 1), Ingredient("orangegem", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("yellowstaff", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("yellowgem", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("greenstaff", {Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("greengem", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)

Recipe("multitool_axe_pickaxe", {Ingredient("goldenaxe", 1),Ingredient("goldenpickaxe", 1), Ingredient("thulecite", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)

Recipe("ruinshat", {Ingredient("thulecite", 4), Ingredient("nightmarefuel", 4)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("armorruins", {Ingredient("thulecite", 6), Ingredient("nightmarefuel", 4)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("ruins_bat", {Ingredient("livinglog", 3), Ingredient("thulecite", 4), Ingredient("nightmarefuel", 4)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)
Recipe("eyeturret_item", {Ingredient("deerclops_eyeball", 1), Ingredient("minotaurhorn", 1), Ingredient("thulecite", 5)}, RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, RECIPE_GAME_TYPE.VANILLA, nil, nil, true)


if ACCOMPLISHMENTS_ENABLED then
	Recipe("accomplishment_shrine", {Ingredient("goldnugget", 10), Ingredient("cutstone", 1), Ingredient("gears", 6)}, RECIPETABS.SCIENCE, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "accomplishment_shrine_placer")
end

----NAUTICAL----
Recipe("lograft", {Ingredient("log", 6), Ingredient("cutgrass", 4)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "lograft_placer", nil, nil, nil, true, 4)
Recipe("raft", {Ingredient("bamboo", 4), Ingredient("vine", 3)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "raft_placer", nil, nil, nil, true, 4)
Recipe("rowboat", {Ingredient("boards", 3), Ingredient("vine", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "rowboat_placer", nil, nil, nil, true, 4)
Recipe("cargoboat", {Ingredient("boards", 6), Ingredient("rope", 3)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "cargoboat_placer", nil, nil, nil, true, 4)
Recipe("armouredboat", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "armouredboat_placer", nil, nil, nil, true, 4)
Recipe("encrustedboat", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("limestone", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "encrustedboat_placer", nil, nil, nil, true, 4)
Recipe("boatrepairkit", {Ingredient("boards", 2), Ingredient("stinger", 2), Ingredient("rope", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("sail", {Ingredient("bamboo", 2), Ingredient("vine", 2), Ingredient("palmleaf", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("clothsail", {Ingredient("bamboo", 2), Ingredient("rope", 2), Ingredient("fabric", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("snakeskinsail", {Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("feathersail", {Ingredient("bamboo", 2), Ingredient("rope", 2), Ingredient("doydoyfeather", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("ironwind", {Ingredient("turbine_blades", 1), Ingredient("transistor", 1), Ingredient("goldnugget", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boatcannon", {Ingredient("log", 5), Ingredient("gunpowder", 4), Ingredient("coconut", 6)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("seatrap", {Ingredient("palmleaf", 4),Ingredient("messagebottleempty", 2), Ingredient("jellyfish", 1)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("trawlnet", {Ingredient("rope", 3), Ingredient("bamboo", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("telescope", {Ingredient("messagebottleempty", 1), Ingredient("pigskin", 1), Ingredient("goldnugget", 1) }, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("supertelescope", {Ingredient("telescope", 1), Ingredient("tigereye", 1), Ingredient("goldnugget", 1) }, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("captainhat", {Ingredient("seaweed", 1), Ingredient("boneshard", 1), Ingredient("strawhat", 1)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("piratehat", {Ingredient("boneshard", 2), Ingredient("rope", 1), Ingredient("silk", 2)}, RECIPETABS.NAUTICAL,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armor_lifejacket", {Ingredient("fabric", 2), Ingredient("vine", 2), Ingredient("messagebottleempty", 3)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("buoy", {Ingredient("messagebottleempty", 1), Ingredient("bamboo", 4), Ingredient("bioluminescence", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "buoy_placer", nil, nil, nil, true)
Recipe("quackeringram", {Ingredient("quackenbeak", 1), Ingredient("bamboo", 4), Ingredient("rope", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)


Recipe("tar_extractor", {Ingredient("coconut", 2), Ingredient("bamboo", 4), Ingredient("limestone", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "tar_extractor_placer", 0, nil, nil, true)
Recipe("sea_yard", {Ingredient("log", 4), Ingredient("tar", 6), Ingredient("limestone", 6)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "sea_yard_placer", nil, nil, nil, true)


Recipe("obsidianmachete", {Ingredient("machete", 1),Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("obsidianaxe", {Ingredient("axe", 1),Ingredient("obsidian", 2), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("spear_obsidian", {Ingredient("spear", 1),Ingredient("obsidian", 3),Ingredient("dragoonheart", 1) }, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("volcanostaff", {Ingredient("firestaff", 1),  Ingredient("obsidian", 4), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("armorobsidian", {Ingredient("armorwood", 1), Ingredient("obsidian", 5), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("obsidiancoconade", {Ingredient("coconade", 3), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true, 3)
Recipe("wind_conch", {Ingredient("obsidian", 4), Ingredient("purplegem", 1), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("sail_stick", {Ingredient("obsidian", 2), Ingredient("nightmarefuel", 3), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)

---- Deconstruction Recipes ----
-- These recipes are for other characters' structures to drop their loot and for some things to be deconstructable.
-- Character recipes here will be overwritten in the character file, so it's safe to register them without tests.

DeconstructRecipe("woodlegsboat", {Ingredient("boatcannon", 1), Ingredient("boards", 4), Ingredient("dubloon", 4)})
DeconstructRecipe("surfboard", {Ingredient("boards", 1), Ingredient("seashell", 2)})

DeconstructRecipe("telipad",  {Ingredient("gears", 1), Ingredient("transistor", 1), Ingredient("cutstone", 2)})
DeconstructRecipe("thumper",  {Ingredient("gears", 1), Ingredient("flint"     , 6), Ingredient("hammer"  , 2)})


DeconstructRecipe("minisign", {Ingredient("boards", 1)})
DeconstructRecipe("spiderhat", {Ingredient("silk", 4), Ingredient("spidergland", 2), Ingredient("monstermeat", 1)})