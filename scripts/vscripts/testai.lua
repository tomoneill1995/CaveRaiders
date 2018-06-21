testai_lua = class({})
LinkLuaModifier("SimpleAI", LUA_MODIFIER_MOTION_HORIZONTAL)

function testai_lua:OnUpgrade()
	print("ai ability created")
	
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "SimpleAI", {duration = 9999999}) --duration unnessecary but giving me error if i dont include
	caster:SetModelScale(2.5)
end

--function testai_lua:OnOwnerSpawned()
--    print("axe AI spawned")
--    
--    local caster = self:GetCaster()
--	caster:AddNewModifier(caster, self, "SimpleAI", {duration = 9999999}) --duration unnessecary but giving me error if i dont include
--    caster:SetModelScale(2.5)
--end