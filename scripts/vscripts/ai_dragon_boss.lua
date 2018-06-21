function Spawn( entityKeyValues )
	dragonsunstrike = thisEntity:FindAbilityByName("dragon_sun_strike")
    dragonfireball = thisEntity:FindAbilityByName("frostivus_fireball")
	
    thisEntity:SetContextThink( "DragonThink", DragonThink , 0.1)
	print("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

end

function CollectWaypoints()

	local waypoint1 = Vector(1185, -6872, 200) --down
    local waypoint2 = Vector(1085, -6972, 200) --corner
    local waypoint3 = Vector(985, -6972, 200) --corner
	local waypoint4 = Vector(-300, -6872, 200) --left
    local waypoint5 = Vector(-500, -6472, 200) --corner
    local waypoint6 = Vector(-500, -6272, 200) --corner
	local waypoint7 = Vector(-300, -3667, 200) --up
    local waypoint8 = Vector(-200, -3567, 200) --corner pt 1
	local waypoint9 = Vector(-100, -3567, 200) --corner pt 2
    local waypoint10 = Vector(0, -3667, 200) --corner pt 3
    local waypoint11 = Vector(2160, -5719, 200) -- down-right
    local waypoint12 = Vector(2460, -5719, 200) --corner pt1
    local waypoint13 = Vector(2560, -5519, 200) --corner pt2
	local waypoint14 = Vector(2160, -3719, 200) --up
    local waypoint15 = Vector(2060, -3619, 200) --corner
    local waypoint16 = Vector(1960, -3619, 200) --corner
    local waypoint17 = Vector(1185, -3619, 200) --start point
    local waypoint18 = Vector(1185, -4000, 200) --center
    local waypoint19 = Vector(100, -5685, 200)  -- down left a bit
    local waypoint20 = Vector(100, -5800, 200) -- corner
    local waypoint21 = Vector(1700, -4000, 200)
    local waypoint22 = Vector(2000, -4500, 200)
    local waypoint23 = Vector(1700, -6300, 200)
    local waypoint24 = Vector(1300, -5500, 200)
    local waypoint25 = Vector(600, -6000, 200)
    local waypoint26 = Vector(450, -4200, 200)
    local waypoint27 = Vector(-1000, -6972, 200)
    local waypoint28 = Vector(-950, -5972, 200)
    local waypoint29 = Vector(-1050, -4900, 200)
    
	
	local waypoints = { waypoint1, waypoint2, waypoint3, waypoint4, waypoint5, waypoint6, waypoint7, waypoint8, waypoint9, waypoint10, waypoint11, waypoint12, waypoint13, waypoint14, waypoint15, waypoint16, waypoint17, waypoint18, waypoint19, waypoint20, waypoint21, waypoint22, waypoint23, waypoint24, waypoint25, waypoint26, waypoint27, waypoint28, waypoint29}
	
	for k,v in pairs(waypoints) do
		print(k,v)
	end

	return waypoints
end

POSITIONS = CollectWaypoints()

waypointshit = 0
currentWaypoint = 1
awake = false
vulnerable = false
laps = 0
sunCD = 0
function DragonThink()
if awake == false then
        
local units = FindUnitsInRadius( thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil,
        1000.0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false )
    
           
    if #units > 0 then
        awake = true
    end
end
if awake == true and vulnerable == false then
	
        local units = FindUnitsInRadius( thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil,
        1000.0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false )
    
           
     if #units > 0 then
        for i, unit in ipairs(units) do 
            if (unit:GetOrigin() - thisEntity:GetAbsOrigin()):Length2D() < 1000 then
                thisEntity:CastAbilityNoTarget(dragonfireball, 0)
            end
        end
    end
  
   
	
    findWaypoint()
    
    if laps == 99 then
    vulnerable = true
    -- do stuff while heroes can attack
    end
    
    
end
    
    if laps >= 1 and laps < 99 and sunCD == 20 then
            print("should cast")
           
            thisEntity:CastAbilityNoTarget(dragonsunstrike, 0)
            sunCD = 0
            thisEntity:MoveToPosition(POSITIONS[currentWaypoint])
    elseif laps >= 1 and sunCD < 20 then
        sunCD = sunCD + 1
    end
    
	return 0.1

end

function findWaypoint()
	local units = FindUnitsInRadius( thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil,
        10000.0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false )
    local distanceToWaypoint = (thisEntity:GetAbsOrigin() - POSITIONS[currentWaypoint]):Length2D()
    print(currentWaypoint)
    print(distanceToWaypoint)
    
    if distanceToWaypoint > 100 and waypointFound == true then
		thisEntity:MoveToPosition(POSITIONS[currentWaypoint])
        
	else
		print("Reached waypoint")
        waypointFound = false
        currentWaypoint = currentWaypoint + 1
        if currentWaypoint == 29 then
            currentWaypoint = 1
        end
        if #units > 0 then
            for i, unit in ipairs(units) do 
                if (unit:GetAbsOrigin() - POSITIONS[currentWaypoint]):Length2D() < 2000 and (thisEntity:GetAbsOrigin() - POSITIONS[currentWaypoint]):Length2D() > 200 then
                    thisEntity:MoveToPosition(POSITIONS[currentWaypoint])
                    waypointFound = true
                    waypointshit = waypointshit + 1
                    if waypointshit == 15 then
                        waypointshit = 0
                        laps = laps + 1
                    end
                    break
                end
            end
        end
    end
    
    
end