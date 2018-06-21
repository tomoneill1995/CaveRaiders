modifier_shagbark_charge = class({})

-------------------------------------------------------------------

function modifier_shagbark_charge:IsHidden()
	return true
end

-------------------------------------------------------------------

function modifier_shagbark_charge:IsPurgable()
	return false
end

-------------------------------------------------------------------

function modifier_shagbark_charge:RemoveOnDeath()
	return false
end

-------------------------------------------------------------------

function modifier_shagbark_charge:OnCreated( kv )
	if IsServer() then
		self.charge_damage = self:GetAbility():GetSpecialValueFor( "charge_damage" )
		self.charge_duration = self:GetAbility():GetSpecialValueFor( "charge_duration" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
       -- stillVelocity = self:GetParent():GetVelocity()
		self.hHitEntities = {}

		--self.hHammer = CreateUnitByName( "npc_dota_beastmaster_axe", self:GetParent():GetOrigin(), false, nil, nil, self:GetParent():GetTeamNumber() )
		--if self.hHammer == nil then
		--	self:Destroy()
		--	return		
		--end

		--self.hHammer:AddEffects( EF_NODRAW )
		--self.hHammer:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beastmaster_axe_invulnerable", kv )

		self.vSourceLoc = self:GetCaster():GetOrigin()
		self.vSourceLoc.z = self.vSourceLoc.z
		self.vTargetLoc = Vector( kv["x"], kv["y"], self.vSourceLoc.z )
        print(self.vTargetLoc)
        print(self.vSourceLoc)
		self.vToTarget = (self.vTargetLoc) - self.vSourceLoc
		self.vDir = self.vToTarget:Normalized()
		self.flDist = self.radius
      
	
		self.flDieTime = GameRules:GetGameTime() + self.charge_duration
		self.bReturning = false

		self.nFXIndex = ParticleManager:CreateParticle( "particles/omniknight_wildaxe.vpcf", PATTACH_CUSTOMORIGIN, nil )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self.GetParent():GetOrigin(), true )

		--EmitSoundOn( "TempleGuardian.HammerThrow", self:GetCaster() )

		self:StartIntervalThink( 0.05 )
	end
end

-------------------------------------------------------------------

function modifier_shagbark_charge:OnIntervalThink()
	if IsServer() then
		local flPct = ( self.flDieTime - GameRules:GetGameTime() ) / self.charge_duration
		local t = 1.0 - flPct 

		local vPos = self.vSourceLoc + ( self.vDir * self.flDist * t * 2 )
		if self.bReturning == true then
			vPos = self.vTargetLoc - ( self.vDir * self.flDist * ( t - 0.5 ) * 2 )
		end
		
		if FrameTime() > 0.0 then
			local vVel = vPos - self:GetParent():GetOrigin() / FrameTime()
			self:GetParent():SetVelocity( vVel )
		end
		
		self:GetParent():SetOrigin( vPos )

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
				self:AddHitTarget( enemy )
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.charge_damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
				--EmitSoundOn( "TempleGuardian.HammerThrow.Damage", enemy )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end	
        local currentLocation = self:GetParent():GetAbsOrigin()
        print(GridNav:IsBlocked(currentLocation))
		--if t >= 0.5 then
		--	self.bReturning = true
		--end
        travelled = self.vSourceLoc - self:GetParent():GetAbsOrigin()
        if travelled:Length2D() > self.radius then	
			self:GetParent():SetVelocity(self:GetParent():GetVelocity() - self:GetParent():GetVelocity())
            self:GetParent():RemoveModifierByName("modifier_shagbark_charge")
		end

	
	end
end

-------------------------------------------------------------------

function modifier_shagbark_charge:OnDestroy()
	if IsServer() then
		--UTIL_Remove( self:GetParent() )
		ParticleManager:DestroyParticle( self.nFXIndex, true )
	end
end

-------------------------------------------------------------------

function modifier_shagbark_charge:HasHitTarget( enemy )
	if IsServer() then
		for _,hitEnemy in pairs( self.hHitEntities ) do
			if hitEnemy == enemy then
				return true
			end
		end
		return false
	end
end

-------------------------------------------------------------------

function modifier_shagbark_charge:AddHitTarget( enemy )
	if IsServer() then
		table.insert( self.hHitEntities, enemy )
	end
end

-------------------------------------------------------------------
