local PREDATOR_SPAWN_DIST = 30

local Breeder = Class(function(self, inst)
    self.inst = inst
    self.crops = {}
    self.volume = 0
    self.max_volume = 4
    self.seeded = false
    self.harvestable = false
    self.level = 1
    self.croppoints = {}
    self.growrate = 1

    self.inst:AddTag("breeder")
end)

function Breeder:IsEmpty()
    return self.volume == 0
end

function Breeder:OnSave()
    local data = {
        harvestable = self.harvestable,
        volume = self.volume,
        seeded = self.seeded,
        product = self.product,
        harvested = self.harvested,
    }

    if self.breedTask then
        data.breedtasktime = GetTaskRemaining(self.breedTask)
    end

    return data
end    

function Breeder:OnLoad(data, newents)
    self.volume = data.volume
    self.seeded = data.seeded
    self.harvestable = data.harvestable
    self.product = data.product
    self.harvested= data.harvested

    if data.breedtasktime then
        self.breedTask = self.inst:DoTaskInTime(data.breedtasktime, function() self:CheckVolume() end)
    end

    self.inst:DoTaskInTime(0, function(inst) inst:PushEvent("onVisChange") end)
end

function Breeder:CheckSeeded()
    if self.volume < 1 and not self.harvestable then
        self:StopBreeding()
    end 
    self.inst:PushEvent("onVisChange")
end

function Breeder:UpdateVolume(delta)
    self.volume = math.clamp(self.volume + delta, 0, self.max_volume)
    self:CheckSeeded()
end

function Breeder:GetPredatorPrefab(pt)
    local prefab = "crocodog"

    if SaveGameIndex:IsModePorkland() then
        prefab = "snake_amphibious"

    elseif math.random() < 0.7 then
        local tile, tileinfo = self.inst:GetCurrentTileType(pt:Get())
    
        if tile == GROUND.OCEAN_DEEP or tile == GROUND.OCEAN_MEDIUM then
            prefab = "sharx"
        end
    end

    return prefab
end

function Breeder:GetPredatorSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = PREDATOR_SPAWN_DIST
    
    local wateroffset =	FindWaterOffset(pt, theta, radius, 36, false)

    if wateroffset then
        local pos = pt + wateroffset
        return pos
    end
end

function Breeder:SummonPredator(harvester)
    local pt = self.inst:GetPosition()
    
    local predators = TheSim:FindEntities(pt.x, pt.y, pt.z, 15, {"breederpredator"})

    if #predators > 2 then
        return nil
    end

    local spawn_pt = self:GetPredatorSpawnPoint(pt)

    if spawn_pt then
        local predator = SpawnPrefab(self:GetPredatorPrefab(pt))

        if predator then
            predator.Physics:Teleport(spawn_pt:Get())
            predator:FacePoint(pt)
            predator.components.combat:SuggestTarget(harvester)
            predator:AddTag("attackingbreeder")
        end
    end
end

function Breeder:CheckVolume()
    if self.seeded then
        self:UpdateVolume(1)

        self.inst:PushEvent("onVisChange")
        local time = math.random(TUNING.FISH_FARM_CYCLE_TIME_MIN,TUNING.FISH_FARM_CYCLE_TIME_MAX)

        self.breedTask = self.inst:DoTaskInTime(time, function() self:CheckVolume() end)
    end
end

function Breeder:Seed(item)

    if not item.components.seedable then
        return false
    end
    
    self:Reset()
    
    local prefab = nil
    if item.components.seedable.product and type(item.components.seedable.product) == "function" then
        prefab = item.components.seedable.product(item)
    else
        prefab = item.components.seedable.product or item.prefab
    end

    self.product = prefab

    self.seeded = true

    local time = math.random(TUNING.FISH_FARM_CYCLE_TIME_MIN,TUNING.FISH_FARM_CYCLE_TIME_MAX)

    self.breedTask = self.inst:DoTaskInTime(time, function() self:CheckVolume() end)

    if self.onseedfn then
        self.onseedfn(item)
    end
    self.inst:PushEvent("onVisChange")
    item:Remove()
    
    return true
end

function Breeder:CanBeHarvested(doer)
    return self.volume > 0
end

function Breeder:CollectSceneActions(doer, actions)
    if self:CanBeHarvested(doer) then
        table.insert(actions, ACTIONS.HARVEST)
    end
end

function Breeder:Harvest(harvester)
    if harvester == nil or not self:CanBeHarvested(harvester) then return end

    self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_small")
    self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/fish_farm/harvest")

    self.harvestable = false
    self.harvested = true

    if harvester.components.inventory then
        local product = SpawnPrefab(self.product)
        harvester.components.inventory:GiveItem(product, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))

        if math.random() <= TUNING.BREEDER_PREDATOR_SPAWN_CHANGE then
            self:SummonPredator(harvester)
        end
    else
        if not harvester:HasTag("breederpredator") then
            harvester.components.lootdropper:SpawnLootPrefab(self.product)
        end
    end

    self:UpdateVolume(-1)

    return true
end

function Breeder:GetDebugString()
    return "seeded: ".. tostring(self.seeded) .." harvestable: ".. tostring(self.harvestable) .." volume: ".. tostring(self.volume)
end

function Breeder:Reset()
    self.harvested = false
    self.seeded = false
    self.harvestable = false
    self.volume = 0
    self.product = nil
    self.inst:PushEvent("onVisChange")
end

function Breeder:StopBreeding()
    self:Reset()
    if self.breedTask then
        self.breedTask:Cancel()
        self.breedTask = nil
    end
end

return Breeder
