




cPlayerState = {}





function cPlayerState:__call(a_Player, a_IsLoggedIn)
	local Obj = {}
	
	setmetatable(Obj, cPlayerState)
	Obj.__index = Obj
	
	Obj.m_UUID       = a_Player:GetUUID()
	Obj.m_IsLoggedIn = a_IsLoggedIn
	Obj.m_StartPos   = Vector3f(a_Player:GetPosition())
	Obj.Teleporting = false;
	
	if (not a_IsLoggedIn) then
		local World = a_Player:GetWorld()
		cRoot:Get():DoWithPlayerByUUID(Obj.m_UUID,
			function(a_Player)
				a_Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
				Obj.Teleporting = true;
			end
		)
	end
	
	return Obj
end





function cPlayerState:IsLoggedIn()
	return self.m_IsLoggedIn
end





function cPlayerState:IsRegistered()
	return self:Exists()
end





function cPlayerState:Exists()
	return g_PassStorage:UUIDExists(self.m_UUID)
end





function cPlayerState:TryLogin(a_Password)
	if (not self:Exists()) then
		return false, "You are not registered yet"
	end
	
	if (g_PassStorage:GetPasswordFromUUID(self.m_UUID) ~= cCryptoHash.md5HexString(a_Password)) then
		return false, "The password is incorrect"
	end
	
	self:TeleportBack()
	self.m_IsLoggedIn = true
	return true
end





function cPlayerState:TryRegister(a_Password)
	if (self:Exists()) then
		return false, "You already have registered"
	end
	
	local res, Err = g_PassStorage:RegisterOrChangePassword(self.m_UUID, a_Password)
	if (not res) then
		return false, Err
	end
	
	return true
end





function cPlayerState:TryChangePassword(a_OldPassword, a_NewPassword)
	if (not self:Exists()) then
		return false, "You are not registered"
	end
	
	if (g_PassStorage:GetPasswordFromUUID(self.m_UUID) ~= cCryptoHash.md5HexString(a_OldPassword)) then
		return false, "The password is incorrect"
	end
	
	local res, Err = g_PassStorage:RegisterOrChangePassword(self.m_UUID, a_NewPassword)
	if (not res) then
		return false, Err
	end
	
	return true
end





function cPlayerState:TeleportBack()
	if (self.m_IsLoggedIn) then
		-- Don't teleport a player when he's already logged in
		return false
	end
	
	-- Mark the player as teleporting. Otherwise the OnPlayerMoving hook might filter the teleport out.
	self.Teleporting = true
	
	cRoot:Get():DoWithPlayerByUUID(self.m_UUID,
		function(a_Player)
			a_Player:TeleportToCoords(
				self.m_StartPos.x,
				self.m_StartPos.y,
				self.m_StartPos.z
			)
		end
	)
	return true
end





setmetatable(cPlayerState, cPlayerState)
cPlayerState.__index = cPlayerState




