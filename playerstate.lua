




local g_PlayerStates = {}





function GetPlayerState(a_Player, a_LoggedIn)
	local LoggedIn = a_LoggedIn or false
	local UUID = a_Player:GetUUID()
	
	if (g_PlayerStates[UUID]) then
		return g_PlayerStates[UUID]
	end
	
	local res = cPlayerState(a_Player, LoggedIn)
	g_PlayerStates[UUID] = res
	
	return res
end





function RemovePlayerState(a_Player)
	local UUID = a_Player:GetUUID()
	g_PlayerStates[UUID] = nil
end




