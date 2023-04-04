local Manager_RoG = require "components/seasonmanager_rog"
local Manager_SW = require "components/seasonmanager_sw"

if SaveGameIndex:IsModeShipwrecked() then
	return Manager_SW
else
	return Manager_RoG
end
