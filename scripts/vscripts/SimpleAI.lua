
--[[
	Adjusted from SimpleAI made by Perry
    perry also answered my questions every 5 seconds
    so he pretty much wrote this this too
    along with arhowk Pongping and K1dney
    Thanks lads
	http://yrrep.me/dota/dota-simple-ai.html
]]
--AI parameter constants
AI_THINK_INTERVAL = 0.5 -- The interval in seconds between two think ticks

--AI state constants
AI_STATE_IDLE = 0
AI_STATE_AGGRESSIVE = 1
AI_STATE_RETURNING = 2


--Define the SimpleAI class
SimpleAI = {}

--[[ Create an instance of the SimpleAI class for some unit 
  with some parameters. ]]
if IsServer() then

function SimpleAI:OnCreated(params)
	   
       
        HammerThrowAbility = self:GetParent():FindAbilityByName( "axe_throw" )
	    findenemydelay = 0
    
    self.unit = self:GetParent()
    bigaxe = self:GetParent() --testing reasons
	self.leashRange = 1500 
        
    self.state = AI_STATE_IDLE
	--Set the core fields for this AI
	
	self.stateThinks = { --Add thinking functions for each state
		[AI_STATE_IDLE] = 'IdleThink',
		[AI_STATE_AGGRESSIVE] = 'AggressiveThink',
		[AI_STATE_RETURNING] = 'ReturningThink'
	}

	--Set parameters values as fields for later use
	self.spawnPos = self:GetParent():GetAbsOrigin()
    
	--Start thinking
	self:StartIntervalThink(AI_THINK_INTERVAL)

end

--[[ The high-level thinker this AI will do every tick, selects the correct
  state-specific think function and executes it. ]]
function SimpleAI:OnIntervalThink()
	--If the unit is dead, stop thinking
    if not self.unit:IsAlive() then
		return nil
	end
        
   -- print(self.state)
	--Execute the think function that belongs to the current state
	self[self.stateThinks[self.state]](self)

end

--[[ Think function for the 'Idle' state. ]]
function SimpleAI:IdleThink()
	--Find any enemy units around the AI unit inside the aggroRange
  self:FindEnemy()
   
	--State behavior
	
end

function SimpleAI:FindEnemy()
    local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
        1000.0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false )

    --If one or more units were found, start attacking the first one
    if #units > 0 then
       -- print(units)
      --  print(#units)
        
        for i, unit in ipairs(units) do 
            if closestunit == nil or (unit:GetOrigin() - self.unit:GetAbsOrigin()):Length2D() < (closestunit:GetOrigin() - self.unit:GetAbsOrigin()):Length2D() then
                closestunit = unit
            end
        
            if furthestunit == nil or (unit:GetOrigin() - self.unit:GetAbsOrigin()):Length2D() > (furthestunit:GetOrigin() - self.unit:GetAbsOrigin()):Length2D() then
                furthestunit = unit
            end
        end
        
        self.unit:MoveToTargetToAttack(closestunit) --Start attacking
        self.aggroTarget = closestunit
        self.farunit = furthestunit
        self.state = AI_STATE_AGGRESSIVE --State transition
    end
        
end

--[[ Think function for the 'Aggressive' state. ]]
function SimpleAI:AggressiveThink()
	if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--Check if the unit's target is still alive (self.aggroTarget will have to be set when transitioning into this state)
	if not self.aggroTarget:IsAlive() then
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--State behavior
	--THROW BIG AXE LIKE STRONG MAN
	if HammerThrowAbility ~= nil and HammerThrowAbility:IsCooldownReady() and self.unit:GetHealthPercent() < 90 then
			local flDist = (self.farunit:GetOrigin() - self:GetParent():GetOrigin()):Length2D()
			if flDist > 600 then
                print ("throw")
				return self:Throw( self.aggroTarget )
			end
	end
    
    if findenemydelay >= 10 then
        self:FindEnemy() --Start attacking
        findenemydelay = 0 
        else
       -- print(findenemydelay)
        findenemydelay = findenemydelay + 1
    end
end

--[[ Think function for the 'Returning' state. ]]
function SimpleAI:ReturningThink()
	
	--Check if the AI unit has reached its spawn location yet
    print(( self.spawnPos - self:GetParent():GetAbsOrigin() ):Length())
	if ( self.spawnPos - self:GetParent():GetAbsOrigin() ):Length() < 100 then
		--Go into the idle state
		self.state = AI_STATE_IDLE
		return true
	end
end
-- THROW

function SimpleAI:Throw( enemy )
    --print( "ai_temple_guardian - Throw" )
 ExecuteOrderFromTable({
	UnitIndex = bigaxe:entindex(),
    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	AbilityIndex = HammerThrowAbility:entindex(),
	Position = enemy:GetOrigin(),
	Queue = false,
	 })
 self.state = AI_STATE_IDLE
end
end