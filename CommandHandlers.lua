




function HandleLoginCommand(a_Split, a_Player)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		a_Player:SendMessage("You are already logged in")
		return true
	end
	
	local Password = a_Split[2]
	if (not Password) then
		a_Player:SendMessage("Usage: /login <password>")
		return true
	end
	
	local res, Err = PlayerState:TryLogin(Password)
	if (not res) then
		a_Player:SendMessage(Err)
		return true
	end
	
	a_Player:SendMessage("You logged in")
	return true
end





function HandleRegisterCommand(a_Split, a_Player)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		a_Player:SendMessage("You are already logged in")
		return true
	end
	
	if ((a_Split[2] == nil) or (a_Split[3] == nil)) then
		a_Player:SendMessage("Usage: /register <password> <confirmpassword>")
		return true
	end
	
	if (a_Split[2] ~= a_Split[3]) then
		a_Player:SendMessage("The password doesn't match the confirmation password")
		return true
	end
	
	local res, Err = PlayerState:TryRegister(a_Split[2])
	if (not res) then
		a_Player:SendMessage(Err)
		return true
	end
	
	a_Player:SendMessage("You have registered")
	return true
end





function HandleChangePassCommand(a_Split, a_Player)
	local PlayerState = GetPlayerState(a_Player)
	if (not PlayerState:IsLoggedIn()) then
		a_Player:SendMessage("Login first before trying to change your name")
		return true
	end
	
	if (#a_Split ~= 4) then
		a_Player:SendMessage(a_Split[1] .. " <current password> <new password> <confirm password>")
		return true
	end
	
	if (a_Split[3] ~= a_Split[4]) then
		a_Player:SendMessage("The new password and confirmation password don't match")
		return true
	end
	
	local res, Err = PlayerState:TryChangePassword(a_Split[2], a_Split[3])
	if (not res) then
		a_Player:SendMessage(Err)
		return true
	end
	
	a_Player:SendMessage("The password is changed")
	return true
end





function HandleRemoveAccountCommand(a_Split, a_Player)
	if (not a_Split[2]) then
		a_Player:SendMessage("Usage: /removeacc <username>")
		return true
	end
	
	-- Remove /removeacc from the split table
	table.remove(a_Split, 1)
	
	-- Get the full username
	local PlayerName = table.concat(a_Split, " ")
	local TargetUUID = GetUUIDFromPlayerName(PlayerName)

	if (not g_PassStorage:UUIDExists(TargetUUID)) then
		a_Player:SendMessage("Player doesn't exist")
		return true
	end
	
	local res, Err = g_PassStorage:DeleteUUID(TargetUUID)
	if (not res) then
		a_Player:SendMessage(Err)
		return true
	end
	
	a_Player:SendMessage("The player is removed")
	return true
end




