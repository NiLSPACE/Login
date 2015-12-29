




-- Contains all the active cPlayerState objects
local g_PlayerStates = {}





-- Defines the cPlayerState object
cPlayerState = {}





function cPlayerState:new(a_Player, a_IsLoggedIn)
	local Obj = {}
	
	setmetatable(Obj, cPlayerState)
	self.__index = self
	
	Obj.m_UUID        = a_Player:GetUUID()
	Obj.m_IsLoggedIn  = a_IsLoggedIn
	Obj.m_StartPos    = Vector3f(a_Player:GetPosition())
	Obj.m_Teleporting = false
	Obj.m_MessageTick = g_Config.LoginMessageTime
	
	if (not a_IsLoggedIn) then
		local World = a_Player:GetWorld()
		Obj:DoWithPlayer(
			function(a_Player)
				a_Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
				Obj.m_Teleporting = true;
			end
		)
	end
	
	return Obj
end





function cPlayerState:DoWithPlayer(a_Callback)
	cRoot:Get():DoWithPlayerByUUID(self.m_UUID, a_Callback)
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





function cPlayerState:TickMessage()
	if (self.m_IsLoggedIn) then
		-- The player is logged in. We don't want to send him any more messages.
		return
	end
	
	self.m_MessageTick = self.m_MessageTick - 1
	if (self.m_MessageTick ~= 0) then
		-- Not enough time has passed to send a new message
		return
	end
	
	local Message
	if (self:Exists()) then
		Message = cCompositeChat():AddTextPart("Please login by using "):AddSuggestCommandPart("/login", "/login", "u")
	else
		Message = cCompositeChat():AddTextPart("Please register by using "):AddSuggestCommandPart("/register", "/register", "u")
	end
	
	self.m_MessageTick = g_Config.LoginMessageTime
	self:DoWithPlayer(
		function(a_Player)
			a_Player:SendMessage(Message)
		end
	)
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
	self.m_Teleporting = true
	
	self:DoWithPlayer(
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





-- Returns the playerstate of a player. If it doesn't exist yet it creates it.
function GetPlayerState(a_Player, a_LoggedIn)
	local LoggedIn = a_LoggedIn or false
	local UUID = a_Player:GetUUID()
	
	if (g_PlayerStates[UUID]) then
		return g_PlayerStates[UUID]
	end
	
	local res = cPlayerState:new(a_Player, LoggedIn)
	g_PlayerStates[UUID] = res
	
	return res
end





-- Removes a player's playerstate
function RemovePlayerState(a_Player)
	local UUID = a_Player:GetUUID()
	g_PlayerStates[UUID] = nil
end




