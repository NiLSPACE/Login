




function InitHooks(a_Plugin)
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,               OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND,    OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,   OnPlayerDestroyed)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK,  OnPlayerLeftClick)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,      OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_SPAWNED,     OnPlayerSpawned)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,        OnTakeDamage)
end





function OnChat(a_Player, a_Message)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		return false
	end
	
	if (PlayerState:IsRegistered()) then
		a_Player:SendMessage(
			cCompositeChat()
			:AddTextPart("Please use ")
			:AddSuggestCommandPart("/login", "/login", "u")
			:AddTextPart(" first before trying to chat.")
		)
	else
		a_Player:SendMessage(
			cCompositeChat()
			:AddTextPart("Please ")
			:AddSuggestCommandPart("register", "/register", "u")
			:AddTextPart(" first before trying to chat.")
		)
	end
	return true
end





function OnExecuteCommand(a_Player, a_Command)
	if (not a_Player) then
		return false
	end
	
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		-- The player is already logged in. Allow him to use any command
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
		return false
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





function OnPlayerDestroyed(a_Player)
	local PlayerState = GetPlayerState(a_Player)
	if (not PlayerState:IsLoggedIn()) then
		PlayerState:TeleportBack()
	end
	
	RemovePlayerState(a_Player)
end





function OnPlayerLeftClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_Action)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		return false
	end
	
	a_Player:SendMessage(
		cCompositeChat()
		:AddTextPart("Please use ")
		:AddSuggestCommandPart("/login", "/login", "u")
		:AddTextPart(" first.")
	)
	return true
end





function OnPlayerMoving(a_Player, a_OldPosition, a_NewPosition)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		return false
	end
	
	if (PlayerState.Teleporting) then
		PlayerState.Teleporting = false -- Player teleported
		return false
	end
	
	local World = a_Player:GetWorld()
	a_Player:TeleportToCoords(
		World:GetSpawnX(),
		World:GetSpawnY(),
		World:GetSpawnZ()
	)
end





function OnPlayerRightClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_CursorX, a_CursorY, a_CursorZ)
	local PlayerState = GetPlayerState(a_Player)
	if (PlayerState:IsLoggedIn()) then
		return false
	end
	
	if (a_BlockFace == BLOCK_FACE_NONE) then
		-- We still block this packet, but we don't send a message because the player could get another message when he was clicking a block
		return true
	end
	
	a_Player:SendMessage(
		cCompositeChat()
		:AddTextPart("Please use ")
		:AddSuggestCommandPart("/login", "/login", "u")
		:AddTextPart(" first.")
	)
	return true
end





function OnPlayerSpawned(a_Player)
	-- Create the playerstate for the player
	local PlayerState = GetPlayerState(a_Player)
	
	if (PlayerState:IsLoggedIn()) then
		-- OnPlayerSpawned is also called when the player respawned, so we can't blindly teleport the player
		return false
	end
	
	-- Teleport the player to the spawn of the world
	local World = a_Player:GetWorld()
	local UUID = a_Player:GetUUID()
	World:QueueTask(
		function()
			cRoot:Get():DoWithPlayerByUUID(UUID,
				function(a_Player)
					-- print(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
					a_Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
				end
			)
		end
	)
end





function OnTakeDamage(a_Receiver, a_TDI)
	if (not a_Receiver:IsPlayer()) then
		return false
	end
	
	local PlayerState = GetPlayerState(a_Receiver)
	if (PlayerState:IsLoggedIn()) then
		-- The receiver is logged in. Check if the attacker is a player and not logged in.
		if (a_TDI.DamageType == dtAttack) then
			if (a_TDI.Attacker:IsPlayer()) then
				local PlayerObj = tolua.cast(a_TDI.Attacker, "cPlayer")
				local AttackerState = GetPlayerState(PlayerObj)
				if (not AttackerState:IsLoggedIn()) then
					return true
				end
			end
		end
		return false
	end
	return true
end




