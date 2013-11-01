--[[Created by STR_Warrior]]--

PassWords = nil
IsAuthedWebAdmin = {}
IsAuthed = {}
PlayerPos = {}

Ticks = 0

function Initialize(Plugin)
	PLUGIN = Plugin
	Plugin:SetVersion(1)
	Plugin:SetName("Login")
	
	LoadSettings(PLUGIN:GetLocalFolder() .. "/Config.ini")
	
	cPluginManager.AddHook(cPluginManager.HOOK_DISCONNECT, OnDisconnect)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
	cPluginManager.AddHook(cPluginManager.HOOK_HANDSHAKE, OnHandshake)
	cPluginManager.AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage)
	cPluginManager.AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	cPluginManager.AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnLeftClick)
	
	local PluginManager = cRoot:Get():GetPluginManager()
	PluginManager:BindCommand("/register",      "login.register",    HandleRegisterCommand,    " - Used to create an account in the Login plugin")
	PluginManager:BindCommand("/login",         "login.login",       HandleLoginCommand,       " - Used to login in the Login plugin")
	PluginManager:BindCommand("/changepass",    "login.changepass",  HandleChangePassCommand,  " - Used to change your password")
	PluginManager:BindCommand("/logout",        "login.logout",      HandleLogoutCommand,      " - Used to logout")
	PluginManager:BindCommand("/removeacc",     "login.removeacc",   HandleRemoveAccCommand,   " - Used to remove an account from the Login plugin")
	PluginManager:BindConsoleCommand("removeacc",              HandleConsoleRemoveAccCommand,  " - Used to remove an account from the Login plugin")
	
	cRoot:Get():ForEachPlayer(function(Player)
		IsAuthed[Player:GetName()] = true
	end)
	
	PassWords = LoadPasswords(PLUGIN:GetLocalFolder() .. "/Passwords.txt")
	
	Plugin:AddWebTab("Manage Plugin", HandleRequest_ManageAccs)
	
	return true
end

function OnDisable()
	cRoot:Get():ForEachPlayer(function(Player)
		if not IsAuthed[Player:GetName()] then
			Player:GetClientHandle():Kick("There was a reload and you were not logged in")
		end
	end)
	PassWords:Save()
end

function LoadPasswords(Path)
	local File = io.open(Path)
	local Table = {}
	if File then
		for I in File:lines() do
			local Split = StringSplit(I, ";")
			Table[Split[1]] = Split[2]
		end
		File:close()
	else
		local File = io.open(Path, "w")
		File:write()
		File:close()
	end
	local Object = {}
	function Object:GetPassFromPlayer(PlayerName)
		if Table[PlayerName] ~= nil then
			return true, Table[PlayerName]
		end
		return false
	end
	
	function Object:AddPass(PlayerName, Password)
		if Table[PlayerName] == nil then
			Table[PlayerName] = md5(Password)
			return true
		end
		return false
	end
	
	function Object:RemovePlayer(PlayerName)
		if Table[PlayerName] ~= nil then
			Table[PlayerName] = nil
			return true
		end
		return false
	end
	
	function Object:ChangePass(PlayerName, NewPassword)
		if Table[PlayerName] ~= nil then
			Table[PlayerName] = md5(NewPassword)
			return true
		end
		return false
	end
	
	function Object:PlayerExists(PlayerName)
		if Table[PlayerName] ~= nil then
			return true
		end
		return false
	end
	
	function Object:ReturnTable()
		return Table
	end
	
	function Object:Save()
		local File = io.open(Path, "w")
		for I, k in pairs(Table) do
			File:write(I .. ";" .. k .. "\n")
		end
		File:close()
	end
	return Object
end

function Logout(Player)
	local PlayerName = Player:GetName()
	local World = Player:GetWorld()
	PlayerPos[PlayerName] = Vector3d(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ())
	Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	IsAuthed[PlayerName] = false
	Player:SendMessage(cChatColor.LightGreen .. "You logged out")
end

function Login(Player)
	local PlayerName = Player:GetName()
	IsAuthed[PlayerName] = true
	Player:TeleportToCoords(PlayerPos[PlayerName].x, PlayerPos[PlayerName].y, PlayerPos[PlayerName].z)
	Player:SendMessage(cChatColor.LightGreen .. "You are now logged in")
end

function LoadSettings(Path)
	local SettingsIni = cIniFile()
	SettingsIni:ReadFile(Path)
	WebAdminPasswordOn = SettingsIni:GetValueSetB("WebAdmin", "WebAdminPasswordOn", false)
	WebAdminPassword = SettingsIni:GetValueSet("WebAdmin", "WebAdminPassword", "Password")
	SettingsIni:WriteFile(Path)
end