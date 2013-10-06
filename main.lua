-- Author STR_Warrior --

AuthDir = {}
Auth = {}
X = {}
Y = {}
Z = {}
Count = {}
PlayerGM = {}
PlayerMSG= {}

-- Code Start

function Initialize( Plugin )

	PLUGIN = Plugin
	Plugin:SetName( "Login" )
	Plugin:SetVersion( 5 )
       
	PluginManager = cRoot:Get():GetPluginManager()
      PluginManager.AddHook( cPluginManager.HOOK_CHAT, OnChat )
      PluginManager.AddHook( cPluginManager.HOOK_PLAYER_TOSSING_ITEM, OnPlayerTossingItem )
	PluginManager.AddHook( cPluginManager.HOOK_DISCONNECT, OnDisconnect )
	PluginManager.AddHook( cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerLeftClick )
	PluginManager.AddHook( cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined )
	PluginManager.AddHook( cPluginManager.HOOK_TICK, OnTick )
	PluginManager.AddHook( cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick )
      PluginManager.AddHook( cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage)
	PluginManager.AddHook( cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand )
      PluginManager.AddHook( cPluginManager.HOOK_HANDSHAKE, OnHandshake)
	
	PluginManager:BindCommand("/changepass",       "login.changepass", 	 HandleChangePasswordCommand,	   " - Change you password");
	PluginManager:BindCommand("/register",         "login.register",     HandleRegisterCommand,            " - Register your account");
	PluginManager:BindCommand("/login",            "login.login",        HandleLoginCommand,               " - Logs you into your account");
	PluginManager:BindCommand("/logout",           "login.logout", 	     HandleLogoutCommand,              " - Logs you out your account");
	PluginManager:BindCommand("/removeacc",        "login.removeacc",    HandleRemoveAccountCommand,       " - Removes a account");
	
	PluginDir = Plugin:GetLocalDirectory() .. "/"
	InitConsoleCommands();
	LoadOnlinePlayers()
	LoadSettings()
	if Storage == "Ini" then
		LoadPasswords()
	end
	
	PLUGIN:AddWebTab("Manage Login",   HandleRequest_Login);
	
	LOG( "Initialized " .. Plugin:GetName() .. " v" .. Plugin:GetVersion() )
	return true
end


function OnDisable()
    local loopPlayers = function( Player )
		if Auth[Player:GetName()] == false then
			local ClientHandle = Player:GetClientHandle()
			ClientHandle:Kick( cChatColor.Rose .. ReloadKick )
		end
    end
    local loopWorlds = function ( World )
        World:ForEachPlayer( loopPlayers )
    end
    cRoot:Get():ForEachWorld( loopWorlds )
	LOG(PLUGIN:GetName() .." v".. PLUGIN:GetVersion() .." is shutting down")
end
