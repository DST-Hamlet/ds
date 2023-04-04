Tuning_SW = require "tuning_override_sw"
Tuning_BaseGame = require "tuning_override_basegame"

if SaveGameIndex:IsModeShipwrecked() or IsDLCInstalled(REIGN_OF_GIANTS) then
	return Tuning_SW
else
	return Tuning_BaseGame
end