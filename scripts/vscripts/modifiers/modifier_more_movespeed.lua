modifier_more_movespeed = class({})


function modifier_more_movespeed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

------------------------------------------------------------------------------------

function modifier_more_movespeed:GetModifierMoveSpeed_Absolute( params )
	return 200
end