




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
	-- TODO
end





function OnPlayerJoined(a_Player)
	print(g_PassStorage:UUIDExists(a_Player:GetUUID()))
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
	
	-- TODO
end





function OnChat(a_Player, a_Message)
	-- TODO
end





function OnPlayerMoving(a_Player, a_OldPosition, a_NewPosition)
	-- TODO
end