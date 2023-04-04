require "class"
require "util"

Ingredient = Class(function(self, type, amount, atlas)
    self.type = type
    self.amount = amount
	self.atlas = (atlas and resolvefilepath(atlas))
					or resolvefilepath("images/inventoryimages.xml")
end)

local num = 0
Recipes = {} -- Don't use this directly, call GetAllRecipes instead
Common_Recipes = {}
Shipwrecked_Recipes = {}
RoG_Recipes = {}
Vanilla_Recipes = {}
Recipes_Merged = false

local function sortrecipe(recipe, gametype, name)
    if gametype == RECIPE_GAME_TYPE.COMMON then
         Common_Recipes[name]      = recipe
    
    elseif gametype == RECIPE_GAME_TYPE.SHIPWRECKED then
         Shipwrecked_Recipes[name] = recipe

    elseif gametype == RECIPE_GAME_TYPE.ROG then
         RoG_Recipes[name] = recipe

    elseif gametype == RECIPE_GAME_TYPE.VANILLA then
        Vanilla_Recipes[name] = recipe
    end
end

Recipe = Class(function(self, name, ingredients, tab, level, game_type, placer, min_spacing, nounlock, numtogive, aquatic, distance)
    self.name          = name
    self.ingredients   = ingredients
    self.product       = name
    self.tab           = tab

    self.atlas         = resolvefilepath("images/inventoryimages.xml")

    self.image         = name .. ".tex"
    self.sortkey       = num
    self.level         = level or {}
    
    self.level.ANCIENT = self.level.ANCIENT or 0
    self.level.MAGIC   = self.level.MAGIC or 0
    self.level.SCIENCE = self.level.SCIENCE or 0
    self.level.OBSIDIAN = self.level.OBSIDIAN or 0 
    self.level.LOST     = self.level.LOST or 0 

    self.placer        = placer
    self.min_spacing   = min_spacing or 3.2

    self.nounlock      = nounlock or false

    self.numtogive     = numtogive or 1

    self.aquatic = aquatic or false
    self.distance = distance or nil 

    num                = num + 1

    self.game_type = game_type or RECIPE_GAME_TYPE.COMMON

    if type(self.game_type) == "table" then
        for i,gametype in ipairs(self.game_type) do
           sortrecipe(self,gametype, name) 
        end
    else
        sortrecipe(self,self.game_type, name) 
    end
end)

function Recipe:GetLevel()
    return self.level
end

function MergeRecipes()

    local valid_recipes = Common_Recipes
    local rog_enabled = true

    if IsDLCInstalled ~= nil then
        rog_enabled = IsDLCInstalled(REIGN_OF_GIANTS)
    end

    if rawget(_G, "SaveGameIndex") == nil then
       valid_recipes = MergeMaps(valid_recipes, Vanilla_Recipes)
       valid_recipes = MergeMaps(valid_recipes, RoG_Recipes)
       valid_recipes = MergeMaps(valid_recipes, Shipwrecked_Recipes)
       return valid_recipes
    end

    -- This has to happen first, since ROG overwrites Vanilla and Shipwrecked overwrites both
    if not SaveGameIndex:IsModeShipwrecked() then
        valid_recipes = MergeMaps(valid_recipes, Vanilla_Recipes)

        if rog_enabled then
            valid_recipes = MergeMaps(valid_recipes, RoG_Recipes)
        end
    else
        valid_recipes = MergeMaps(valid_recipes, Shipwrecked_Recipes)
    end

    return valid_recipes
end

function GetAllRecipes(force_merge)
    if force_merge or not Recipes_Merged then
        Recipes = MergeRecipes()
        Recipes_Merged = true
    end
	return Recipes
end

-- Unlike MergeRecipes this returns the recipes we know about, not just the ones we can craft in this mode
function GetAllKnownRecipes()
    local valid_recipes = Common_Recipes
    valid_recipes = MergeMaps(valid_recipes, Vanilla_Recipes)
    valid_recipes = MergeMaps(valid_recipes, RoG_Recipes)
    valid_recipes = MergeMaps(valid_recipes, Shipwrecked_Recipes)
	return valid_recipes
end

function GetRecipe(name)
    local valid_recipes = GetAllRecipes()
    return valid_recipes[name]
end
