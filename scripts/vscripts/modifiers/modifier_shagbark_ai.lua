AI_THINK_INTERVAL = 0.5 -- The interval in seconds between two think ticks

--AI state constants
AI_STATE_IDLE = 0
AI_STATE_AGGRESSIVE = 1
AI_STATE_RETURNING = 2


--Define the modifier_shagbark_ai class
modifier_shagbark_ai = {}

--[[ Create an instance of the modifier_shagbark_ai class for some unit 
  with some parameters. ]]
if IsServer() then

function modifier_shagbark_ai:OnCreated(params)
	   
       
        self.ChargeAbility = self:GetCaster():FindAbilityByName( "shagbark_charge" )
	    self.findenemydelay = 0
    
    self.unit = self:GetParent()
  
	self.leashRange = 2500
        
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
function modifier_shagbark_ai:OnIntervalThink()
	--If the unit is dead, stop thinking
    if not self.unit:IsAlive() then
		return nil
	end
        
   -- print(self.state)
	--Execute the think function that belongs to the current state
	self[self.stateThinks[self.state]](self)

end

--[[ Think function for the 'Idle' state. ]]
function modifier_shagbark_ai:IdleThink()
	--Find any enemy units around the AI unit inside the aggroRange
  local wakeup = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
        700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false )
        
        
  if #wakeup > 0 or self.awake == true then
   self.awake = true
   self:FindEnemy()
  end
	--State behavior
	
end

function modifier_shagbark_ai:FindEnemy()
    local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
        4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
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
        
       
        self.aggroTarget = units[1]
        self.farunit = furthestunit
        self.state = AI_STATE_AGGRESSIVE --State transition
        
        if self.findenemydelay >= 10 then
        self.unit:MoveToTargetToAttack(self.aggroTarget) --Start attacking
        self.findenemydelay = 0 
        else
       -- print(findenemydelay)
        self.findenemydelay = self.findenemydelay + 1
        end
        
    end
        
end

--[[ Think function for the 'Aggressive' state. ]]
function modifier_shagbark_ai:AggressiveThink()
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
	if self.ChargeAbility ~= nil and self.ChargeAbility:IsCooldownReady() then
       if ((self.aggroTarget:GetAbsOrigin() - self.unit:GetAbsOrigin()):Length2D()) < 800 then
                print("Charge")
	            self:Charge(self.aggroTarget)
                else
                self.unit:MoveToTargetToAttack(self.aggroTarget)
       end
    end
    
     self:FindEnemy() --Start attacking
       
end

--[[ Think function for the 'Returning' state. ]]
function modifier_shagbark_ai:ReturningThink()
	
	--Check if the AI unit has reached its spawn location yet
	if ( self.spawnPos - self:GetParent():GetAbsOrigin() ):Length() < 100 then
		--Go into the idle state
		self.state = AI_STATE_IDLE
		return true
	end
end

function modifier_shagbark_ai:Charge( enemy )
    --print( "ai_temple_guardian - Throw" )
 ExecuteOrderFromTable({
	UnitIndex = self:GetCaster():entindex(),
    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	AbilityIndex = self.ChargeAbility:entindex(),
	Position = enemy:GetOrigin(),
	Queue = false,
	 })
    self:CheckState()
    
 self.state = AI_STATE_IDLE

end

function modifier_shagbark_ai:CheckState()
	local state = {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
 
	return state
end
    
end