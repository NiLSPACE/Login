




function Initialize(a_Plugin)
	a_Plugin:SetName("Login")
	a_Plugin:SetVersion(g_PluginInfo.Version)
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	-- Load and initialize the config.
	InitConfig()
	
	-- Load the password storage according to the config file
	InitStorage()
	
	-- Load the hooks
	InitHooks()
	
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			-- Log all the users that are currently online in
			GetPlayerState(a_Player, true)
		end
	)
	
	if (g_Config.NetworkAPI.Enabled) then
		InitNetworkAPI(g_Config.NetworkAPI.Port)
		LOGINFO("[Login] API is running on port " .. g_Config.NetworkAPI.Port)
	end
	
	LOG("Login is initialized")
	return true
end





function OnDisable()
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			local PlayerState = GetPlayerState(a_Player)
			if (not PlayerState:IsLoggedIn()) then
				PlayerState:TeleportBack()
				a_Player:GetClientHandle():Kick("The server reloaded while you were not logged in")
			end
		end
	)
	
	g_PassStorage:Disable()
	DisableNetworkAPI()
end




