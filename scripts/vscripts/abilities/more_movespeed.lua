more_movespeed = class({})
LinkLuaModifier( "modifier_more_movespeed", "modifiers/modifier_more_movespeed", LUA_MODIFIER_MOTION_NONE )
function more_movespeed:OnUpgrade()
	print("movespeed upgraded")
	
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_bloodseeker_thirst", {duration = 9999999}) --duration unnessecary but giving me error if i dont include
    
end