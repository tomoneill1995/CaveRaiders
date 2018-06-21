shagbark_charge = class({})
LinkLuaModifier( "modifier_shagbark_charge", "modifiers/modifier_shagbark_charge", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function shagbark_charge:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/generic_attack_charge.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 235, 292, 335 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

		--EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function shagbark_charge:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )
	end 
end

--------------------------------------------------------------------------------

function shagbark_charge:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------

function shagbark_charge:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		
		local vLocation = self:GetCursorPosition()

		local kv = 
		{
			x = vLocation.x,
			y = vLocation.y,
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_shagbark_charge", kv )
	end
end