




function isArray(a_Table)
	local i = 0
	for _, t in pairs(a_Table) do
		i = i + 1
		if (not rawget(a_Table, i)) then
			return false
		end
	end
	
	return true
end





function GetUUIDFromPlayerName(a_PlayerName)
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		return cMojangAPI:GetUUIDFromPlayerName(a_PlayerName, true)
	else
		return cClientHandle:GenerateOfflineUUID(a_PlayerName)
	end
end



