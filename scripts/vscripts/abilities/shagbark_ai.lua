shagbark_ai = class({})
LinkLuaModifier("modifier_shagbark_ai", "modifiers/modifier_shagbark_ai", LUA_MODIFIER_MOTION_HORIZONTAL)

function shagbark_ai:OnUpgrade()
	print("shagbark ai ability created")
	
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_shagbark_ai", {duration = 9999999}) --duration unnessecary but giving me error if i dont include
end