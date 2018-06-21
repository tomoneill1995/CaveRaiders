function sun_strike_cast(keys)
 local all_heroes = HeroList:GetAllHeroes()
            
    for _,hero in pairs(all_heroes) do
      if hero:IsAlive() then
        
        
      caster = keys.caster
	  caster_team = caster:GetTeam()
	  target_location = hero:GetAbsOrigin()
	  ability = keys.ability
        
	  -- Ability variables
	  local charge_particle = keys.charge_particle
	  delay = 1.7
	  area_of_effect = 175
	  vision_duration = 4 
	  vision_distance = 400

	  -- Create the vision
	  local duration = delay + vision_duration
	  ability:CreateVisibilityNode(target_location, vision_distance, vision_duration)

	  -- Create the sun strike charge up particle for each player on the caster team
	  for _,hero in pairs(all_heroes) do
			local particle = ParticleManager:CreateParticleForPlayer(charge_particle, PATTACH_ABSORIGIN, hero, PlayerResource:GetPlayer(hero:GetPlayerID()))
			ParticleManager:SetParticleControl(particle, 0, target_location) 
			ParticleManager:SetParticleControl(particle, 1, Vector(area_of_effect,0,0))

			-- Remove the particle after the charging is done
			Timers:CreateTimer(delay, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
		
	  end
        
        
       GameRules:GetGameModeEntity():SetThink(sun_strike_damage, 1.7)  
      end
    end
end


--[[Author: Pizzalol
	Date: 20.04.2015.
	Deal damage split between enemy heroes depending on the level of Exort]]
function sun_strike_damage( keys )
    local all_heroes = HeroList:GetAllHeroes()
    for _,hero in pairs(all_heroes) do
			local particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_ABSORIGIN, hero, PlayerResource:GetPlayer(hero:GetPlayerID()))
			ParticleManager:SetParticleControl(particle, 0, target_location) 
			ParticleManager:SetParticleControl(particle, 1, Vector(area_of_effect,0,0))

			-- Remove the particle after the charging is done
			Timers:CreateTimer(delay, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
    end
	local damage = 800

	-- Targeting variables
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()

	local found_targets = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, area_of_effect, target_teams, target_types, target_flags, FIND_CLOSEST, false)

	-- Initialize the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage = damage / #found_targets

	-- Deal damage to each found hero
	for _,hero in pairs(found_targets) do
		damage_table.victim = hero
		ApplyDamage(damage_table)
	end
end