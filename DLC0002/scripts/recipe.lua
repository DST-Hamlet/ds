require "class"
require "util"

Ingredient = Class(function(self, type, amount, atlas)
    self.type = type
    self.amount = amount
	self.atlas = (atlas and resolvefilepath(atlas))
end)

function Ingredient:GetAtlas(imagename)
	self.atlas = self.atlas or resolvefilepath(GetInventoryItemAtlas(imagename))
	return self.atlas
end

local num = 0
Recipes = {} -- Don't use this directly, call GetAllRecipes instead
Common_Recipes = {}
Shipwrecked_Recipes = {}
RoG_Recipes = {}
Vanilla_Recipes = {}
Recipes_Merged = false

local function primerecipe(recipe, gametype, name)
    if not Common_Recipes[name] then
        Common_Recipes[name]      = recipe
    end
end

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

    self.image         = name .. ".tex"

    local oldsortkey = nil
    if Common_Recipes[name] then
        oldsortkey = Common_Recipes[name].sortkey
    elseif Shipwrecked_Recipes[name] then
        oldsortkey = Shipwrecked_Recipes[name].sortkey
    elseif RoG_Recipes[name] then
        oldsortkey = RoG_Recipes[name].sortkey
    elseif Vanilla_Recipes[name] then
        oldsortkey = Vanilla_Recipes[name].sortkey
    end

    self.sortkey = oldsortkey or num
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

    local copy = deepcopy(self)
    copy.game_type = RECIPE_GAME_TYPE.COMMON
    copy.tab = self.tab
    copy.level = {}
    copy.level = TECH.LOST

    local insert = true

    if self.game_type == RECIPE_GAME_TYPE.ROG and IsDLCInstalled and not IsDLCInstalled(REIGN_OF_GIANTS) then    
        print("REMOVING ROG",name)
        insert = false
    end

    if insert then
        primerecipe(copy,"common", name)
    
        if type(self.game_type) == "table" then
            for i,gametype in ipairs(self.game_type) do
               sortrecipe(self,gametype, name) 
            end
        else
            sortrecipe(self,self.game_type, name) 
        end
    end
end)

function Recipe:GetAtlas()
	self.atlas = self.atlas or resolvefilepath(GetInventoryItemAtlas(self.image))
	return self.atlas
end

function Recipe:GetLevel()
    return self.level
end

DeconstructRecipe = Class(Recipe, function(self, name, return_ingredients)
    Recipe._ctor(self, name, return_ingredients, nil, TECH.NONE)
    self.is_deconstruction_recipe = true
    self.nounlock = true
end)

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
    if SaveGameIndex:IsModeShipwrecked() then
        valid_recipes = MergeMaps(valid_recipes, Shipwrecked_Recipes)
    else
        valid_recipes = MergeMaps(valid_recipes, Vanilla_Recipes)

        if rog_enabled then
            valid_recipes = MergeMaps(valid_recipes, RoG_Recipes)            
        end
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
