function OnStartTouch(trigger)
 
	trigger.activator:SetHealth(200)
 
end
 
function OnEndTouch(trigger)
 
	trigger.activator:SetHealth(10000)
 
end