local DynamicMusic = Class(function(self, inst)
    self.inst = inst
    self.inst:StartUpdatingComponent(self)
    
    self.enabled = true

    self.is_busy = false
    self.busy_timeout = 0

    self.is_boating = false 
    self.boating_timeout = 0
    self.phase = nil
    
    self.playing_danger = false
    self.season = nil--GetSeasonManager() and GetSeasonManager().current_season or SEASONS.AUTUMN
    
    self.inst:ListenForEvent( "gotnewitem", function() self:OnContinueBusy() end )  
    self.inst:ListenForEvent( "dropitem", function() self:OnContinueBusy() end )  
    
    self.inst:ListenForEvent( "attacked", function(inst, dat)
        if self.enabled
           and dat.attacker
           and dat.attacker ~= self.inst
           and not dat.attacker:HasTag("shadow") 
           and not dat.attacker:HasTag("thorny")
           and not dat.attacker:HasTag("coconut")
           and not (dat.attacker.components.burnable and dat.attacker.components.burnable:IsSmoldering()) then
            print("start music")
            self:OnStartDanger()
        end
    end )  
    self.inst:ListenForEvent( "doattack", function(inst, dat)
		if self.enabled
            and dat
            and dat.target
            and dat.target.components.combat
		    and not dat.target:HasTag("prey")
			and not dat.target:HasTag("bird")
			and not dat.target:HasTag("wall")
			and not dat.target:HasTag("butterfly")
			and not dat.target:HasTag("shadow")
			and not dat.target:HasTag("veggie")
            and not dat.target:HasTag("smashable") then
			self:OnStartDanger()
		end
	end )  
    self.inst:ListenForEvent( "resurrect", function(inst)
        self:StopPlayingDanger()
    end)
    
  
    self.inst:ListenForEvent( "dusktime", function(it, data) 
            
            if self.enabled and 
                not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") and
                data.newdusk then
                self:StopPlayingBusy()
                self:StopPlayingBoating()
                self:StopPlayingSurfing()
                if SaveGameIndex:IsModeShipwrecked() then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_dusk_stinger")
                else
                    self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_dusk_stinger")
                end
            end
            
            
        end, GetWorld())      

    self.inst:ListenForEvent( "daytime", function(it, data) 

            if self.enabled and 
                data.day > 0 and not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") then
                self:StopPlayingBusy()
                self:StopPlayingBoating()
                self:StopPlayingSurfing()
                if SaveGameIndex:IsModeShipwrecked() then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_dawn_stinger", "dawn")
                else
                    self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_dawn_stinger", "dawn")
                end
            end
            
        end, GetWorld())

    self.inst:ListenForEvent( "arrive", function(it, data)
        if data and data.mode == "volcano" then
            if GetVolcanoManager():IsErupting() then
                self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/music/music_volcano_active")
            else
                self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/music/music_volcano_dormant")
            end
        end
    end, GetWorld())

    self.inst:ListenForEvent( "OnVolcanoEruptionBegin", function(it, data)
        self:OnStartErupt()
    end, GetWorld())

    self.inst:ListenForEvent( "OnVolcanoEruptionEnd", function(it, data)
        self:StopPlayingErupt()
    end, GetWorld())
    
    inst:ListenForEvent( "builditem", function(it, data) self:OnStartBusy() end)  
    inst:ListenForEvent( "buildstructure", function(it, data) self:OnStartBusy() end)  
    inst:ListenForEvent( "working", function(it, data) self:OnStartBusy() end)

    inst:ListenForEvent("mountboat", function(it, data)
        if data and data.boat and data.boat.prefab == "surfboard" then
            self:OnStartSurfing()
        else
            self:OnStartBoating()
        end
    end)
    inst:ListenForEvent("dismountboat", function(it, data)
        self:StopPlayingBoating()
        self:StopPlayingSurfing()
    end)
    
    
end)


function DynamicMusic:StartPlayingBusy()
	if GetWorld():IsRuins() then
		self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work_ruins", "busy")
	elseif GetWorld():IsCave() then
		self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work_cave", "busy")
	elseif GetSeasonManager():IsWinter() then
		self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work_winter", "busy")
	elseif GetSeasonManager():IsSpring() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC001/music/music_work_spring", "busy")
    elseif GetSeasonManager():IsSummer() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC001/music/music_work_summer", "busy")
    elseif GetSeasonManager():IsMildSeason() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_1", "busy")
    elseif GetSeasonManager():IsWetSeason() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_2", "busy")
    elseif GetSeasonManager():IsGreenSeason() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_3", "busy")
    elseif GetSeasonManager():IsDrySeason() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_4", "busy")
    else
		self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work", "busy")
	end
	
	self.inst.SoundEmitter:SetParameter( "busy", "intensity", 0 )
end

function DynamicMusic:Enable()
    self.enabled = true

end


function DynamicMusic:Disable()
    self.enabled = false
    self:StopPlayingBusy()
    self:StopPlayingDanger()
end

function DynamicMusic:StopPlayingBusy()
    self.inst.SoundEmitter:SetParameter( "busy", "intensity", 0 )
end

function DynamicMusic:OnStartBusy()
	
    if not self.enabled then return end

	if not self.busy_started then
		self.busy_started = true
		self:StartPlayingBusy()
	end

    local day = GetClock():IsDay()
    if (day or GetWorld():IsCave()) and not self.inst.SoundEmitter:PlayingSound("dawn") then
        self.busy_timeout = 15
        
        if not self.is_busy then
            self.is_busy = true
            if not self.playing_danger and not self.is_boating and not self.inst.SoundEmitter:PlayingSound("erupt") then
                self.inst.SoundEmitter:SetParameter( "busy", "intensity", 1 )
            end
        end
    end
end

function DynamicMusic:StartPlayingBoating()
    if GetClock():IsDay() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_sailing_day", "boating")
    else
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_sailing_night", "boating")
    end
    self.inst.SoundEmitter:SetParameter( "boating", "intensity", 0 )
end

function DynamicMusic:StopPlayingBoating()
    self.inst.SoundEmitter:SetParameter( "boating", "intensity", 0 )
    self.is_boating = false
end

function DynamicMusic:OnStartBoating()
    if not self.enabled then return end

    if not self.inst.SoundEmitter:PlayingSound("boating") then
        self:StartPlayingBoating()
    end

    self:StopPlayingSurfing()

    if not self.inst.SoundEmitter:PlayingSound("dawn") then
        self.boating_timeout = 75
        
        if not self.is_boating then
            self.is_boating = true
            if not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") then
                self:StopPlayingBusy()
                self.inst.SoundEmitter:SetParameter( "boating", "intensity", 1 )
            end
        end
    end
end

function DynamicMusic:StartPlayingSurfing()
    if GetClock():IsDay() then
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_surfing_day", "surfing")
    else
        self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_surfing_night", "surfing")
    end
    self.inst.SoundEmitter:SetParameter( "surfing", "intensity", 0 )
end

function DynamicMusic:StopPlayingSurfing()
    self.inst.SoundEmitter:SetParameter( "surfing", "intensity", 0 )
    self.is_boating = false
end

function DynamicMusic:OnStartSurfing()
    if not self.enabled then return end

    if not self.inst.SoundEmitter:PlayingSound("surfing") then
        self:StartPlayingSurfing()
    end

    self:StopPlayingSurfing()

    if not self.inst.SoundEmitter:PlayingSound("dawn") then
        self.boating_timeout = 75
        
        if not self.is_boating then
            self.is_boating = true
            if not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") then
                self:StopPlayingBusy()
                self.inst.SoundEmitter:SetParameter( "surfing", "intensity", 1 )
            end
        end
    end
end

function DynamicMusic:OnStartDanger()

    if not self.enabled then return end
    
    self.danger_timeout = 10
    if not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") then
        local epic = GetClosestInstWithTag("epic", self.inst, 45)
        local soundpath = nil
        
        if epic then
            if GetWorld():IsRuins() then
				soundpath = "dontstarve/music/music_epicfight_ruins"
            elseif GetWorld():IsCave() then
				soundpath = "dontstarve/music/music_epicfight_cave"
            elseif GetSeasonManager():IsWinter() then
				soundpath = "dontstarve/music/music_epicfight_winter"
			elseif GetSeasonManager():IsSpring() then
                soundpath = "dontstarve_DLC001/music/music_epicfight_spring"
            elseif GetSeasonManager():IsSummer() then
                soundpath = "dontstarve_DLC001/music/music_epicfight_summer"
            elseif GetSeasonManager():IsMildSeason() then
                soundpath = "dontstarve_DLC002/music/music_epicfight_season_1"
            elseif GetSeasonManager():IsWetSeason() then
                soundpath = "dontstarve_DLC002/music/music_epicfight_season_2"
            elseif GetSeasonManager():IsGreenSeason() then
                soundpath = "dontstarve_DLC002/music/music_epicfight_season_3"
            elseif GetSeasonManager():IsDrySeason() then
                soundpath = "dontstarve_DLC002/music/music_epicfight_season_4"
            else
				soundpath = "dontstarve/music/music_epicfight"
			end
        elseif GetWorld():IsRuins() then
            soundpath = "dontstarve/music/music_danger_ruins"
        elseif GetWorld():IsCave() then
            soundpath = "dontstarve/music/music_danger_cave"
        elseif GetSeasonManager():IsWinter() then
			soundpath = "dontstarve/music/music_danger_winter"
		elseif GetSeasonManager():IsSpring() then
            soundpath = "dontstarve_DLC001/music/music_danger_spring"
        elseif GetSeasonManager():IsSummer() then
            soundpath = "dontstarve_DLC001/music/music_danger_summer"
        elseif GetSeasonManager():IsMildSeason() then
            soundpath = "dontstarve_DLC002/music/music_danger_season_1"
        elseif GetSeasonManager():IsWetSeason() then
            soundpath = "dontstarve_DLC002/music/music_danger_season_2"
        elseif GetSeasonManager():IsGreenSeason() then
            soundpath = "dontstarve_DLC002/music/music_danger_season_3"
        elseif GetSeasonManager():IsDrySeason() then
            soundpath = "dontstarve_DLC002/music/music_danger_season_4"
        else
			soundpath = "dontstarve/music/music_danger"
        end

        self.inst.SoundEmitter:PlaySound(soundpath, "danger")
        self:StopPlayingBusy()
        self:StopPlayingBoating()
        self:StopPlayingSurfing()
        self.playing_danger = true
    end
end

function DynamicMusic:StopPlayingDanger()
    self.inst.SoundEmitter:KillSound("danger")
    self.playing_danger = false
end

function DynamicMusic:OnStartErupt()
    if not self.enabled then return end

    if not self.inst.SoundEmitter:PlayingSound("erupt") then
        self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/music/music_volcano_active", "erupt")
        self:StopPlayingBusy()
        self:StopPlayingBoating()
        self:StopPlayingSurfing()
        self:StopPlayingDanger()
        self.inst.SoundEmitter:KillSound("dawn")
    end
end

function DynamicMusic:StopPlayingErupt()
    self.inst.SoundEmitter:KillSound("erupt")
end

function DynamicMusic:OnContinueBusy()
    if self.is_busy then
        self.busy_timeout = 10
    end
end

function DynamicMusic:OnUpdate(dt)
    if self.season == nil then 
        self.season = GetSeasonManager() and GetSeasonManager().current_season or SEASONS.AUTUMN
    end 
    if self.danger_timeout and self.danger_timeout > 0 then
        self.danger_timeout = self.danger_timeout - dt
        if self.danger_timeout <= 0 then
            self:StopPlayingDanger()
        end
    end

    if self.busy_timeout and self.busy_timeout > 0 then
        self.busy_timeout = self.busy_timeout - dt
        if self.busy_timeout <= 0 then
            self:StopPlayingBusy()
            self.is_busy = false
        end
    end

    if self.boating_timeout and self.boating_timeout > 0 then
        self.boating_timeout = self.boating_timeout - dt
        if self.boating_timeout<= 0 then
            self:StopPlayingBoating()
            self:StopPlayingSurfing()
        end
    end

    local clock = GetClock()
    if self.phase == nil then
        self.phase = clock:GetPhase()
    end
    if not self.is_boating and clock:GetPhase() ~= self.phase then
        self.inst.SoundEmitter:KillSound("boating")
        self.inst.SoundEmitter:KillSound("surfing")
        self:StartPlayingBoating()
        self:StartPlayingSurfing()
        self.phase = clock:GetPhase()
    end
    
    if not self.is_busy then
        
        if not GetWorld():IsCave() then
        
            if GetSeasonManager().current_season ~= self.season then
                self.inst.SoundEmitter:KillSound("busy")
		
				self.season = GetSeasonManager().current_season
				if self.season == SEASONS.WINTER then
					self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work_winter", "busy")
				elseif self.season == SEASONS.SPRING then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC001/music/music_work_spring", "busy")
                elseif self.season == SEASONS.SUMMER then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC001/music/music_work_summer", "busy")
                elseif self.season == SEASONS.MILD then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_1", "busy")
                elseif self.season == SEASONS.WET then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_2", "busy")
                elseif self.season == SEASONS.GREEN then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_3", "busy")
                elseif self.season == SEASONS.DRY then
                    self.inst.SoundEmitter:PlaySound( "dontstarve_DLC002/music/music_work_season_4", "busy")
                else --autumn
					self.inst.SoundEmitter:PlaySound( "dontstarve/music/music_work", "busy")
				end
			end
		end
    end
end

function DynamicMusic:GetDebugString()
    local s = string.format("busy %s, %4.2f\n", tostring(self.inst.SoundEmitter:PlayingSound("busy")), self.busy_timeout or 0)
    s = s .. string.format("boating %s, %4.2f\n", tostring(self.inst.SoundEmitter:PlayingSound("boating")), self.boating_timeout or 0)
    s = s .. string.format("surfing %s, %4.2f\n", tostring(self.inst.SoundEmitter:PlayingSound("surfing")), self.boating_timeout or 0)
    s = s .. string.format("dawn %s\n", tostring(self.inst.SoundEmitter:PlayingSound("dawn")))
    s = s .. string.format("danger %s, %4.2f\n", tostring(self.inst.SoundEmitter:PlayingSound("danger")), self.danger_timeout or 0)
    s = s .. string.format("erupt %s\n", tostring(self.inst.SoundEmitter:PlayingSound("erupt")))
    return s
end

return DynamicMusic

