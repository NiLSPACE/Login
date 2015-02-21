




function Initialize(a_Plugin)
	a_Plugin:SetName("Login")
	a_Plugin:SetVersion(2)
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	InitConfig()
	InitStorage()
	InitHooks()
	
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			GetPlayerState(a_Player, true)
		end
	)
	
	LOG("Login is initialized")
	return true
end





function OnDisable()
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			local PlayerState = GetPlayerState(a_Player)
			if (not PlayerState:IsLoggedIn()) then
				a_Player:TeleportBack()
				a_Player:GetClientHandle():Kick("The server reloaded while you were not logged in")
			end
		end
	)
	
	g_PassStorage:Disable()
end




