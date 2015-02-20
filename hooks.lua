




function InitHooks(a_Plugin)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED, OnPlayerDestroyed)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,    OnPlayerJoined)
	-- cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_SPAWNED,   OnPlayerSpawned)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,      OnTakeDamage)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND,  OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,             OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,    OnPlayerMoving)
end





function OnPlayerDestroyed(a_Player)
	RemovePlayerState(a_Player)
end





function OnPlayerJoined(a_Player)
	GetPlayerState(a_Player) -- Create the playerstate for the player
	-- print(a_Player:GetUUID(), g_PassStorage:GetPasswordFromUUID(a_Player:GetUUID()), g_PassStorage:GetPasswordFromUUID(a_Player:GetUUID()) == md5("admin"))
	-- TODO
end





function OnTakeDamage(a_Receiver, a_TDI)
	if (not a_Receiver:IsPlayer()) then
		return false
	end
	
	-- TODO
end





function OnExecuteCommand(a_Player, a_Command)
	if (not a_Player) then
		return false
	end
	
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		return false
	end
	
	if (PlayerState:IsRegistered()) then
		if (a_Command[1] ~= "/login") then
			a_Player:SendMessage(
				cCompositeChat()
				:AddTextPart("Please use ")
				:AddSuggestCommandPart("/login", "/login", "u")
				:AddTextPart(" first before trying to execute a command.")
			)
			return true
		end
		return true
	end
	
	if (a_Command[1] == "/register") then
		return false
	end
	
	a_Player:SendMessage(
		cCompositeChat()
		:AddTextPart("Please use ")
		:AddSuggestCommandPart("/register", "/register", "u")
		:AddTextPart(" first before trying to execute a command.")
	)
	return true
end





function OnChat(a_Player, a_Message)
	-- TODO
end





function OnPlayerMoving(a_Player, a_OldPosition, a_NewPosition)
	-- TODO
end




