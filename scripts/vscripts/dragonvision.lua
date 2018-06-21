function OnStartTouch(trigger)
 
trigger.activator:SetDayTimeVisionRange(4000)
trigger.activator:SetNightTimeVisionRange(4000)
GameRules:GetGameModeEntity():SetCameraDistanceOverride(2400)
 
end
 
function OnEndTouch(trigger)
 
trigger.activator:SetDayTimeVisionRange(1800)
trigger.activator:SetNightTimeVisionRange(1800)
GameRules:GetGameModeEntity():SetCameraDistanceOverride(1600)
end
