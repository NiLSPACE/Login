




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
	
	local res, Err = PlayerState:TryRegister(a_Split[2], a_Split[3])
	if (not res) then
		a_Player:SendMessage(Err)
		return true
	end
	
	a_Player:SendMessage("You have registered")
	return true
end





