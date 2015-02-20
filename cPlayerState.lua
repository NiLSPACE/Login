



cPlayerState = {}




function cPlayerState:__call(a_UUID, a_IsLoggedIn)
	local Obj = {}
	
	setmetatable(Obj, cPlayerState)
	Obj.__index = Obj
	
	Obj.m_UUID       = a_UUID;
	Obj.m_IsLoggedIn = a_IsLoggedIn
	
	return Obj
end





function cPlayerState:IsLoggedIn()
	return self.m_IsLoggedIn
end





function cPlayerState:Exists()
	 g_PassStorage:UUIDExists(self.m_UUID)
end





function cPlayerState:TryLogin(a_Password)
	if (not self:Exists()) then
		return false, "You are not registered yet"
	end
	
	if (g_PassStorage:GetPasswordFromUUID(self.m_UUID) ~= md5(a_Password)) then
		return false, "The password is incorrect"
	end
	
	self.m_IsLoggedIn = true
end





function cPlayerState:TryRegister(a_Password, a_ConfirmPassword)
	if (self:Exists()) then
		return false, "You already have registered"
	end
	
	if (a_Password ~= a_ConfirmPassword) then
		return false, "The 2 passwords do not match"
	end
	
	local res, Err = g_PassStorage:UpdatePassword(self.m_UUID, a_Password)
	if (not res) then
		return false, Err
	end
	
	return true
end





setmetatable(cPlayerState, cPlayerState)
cPlayerState.__index = cPlayerState




