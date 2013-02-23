-- Author STR_Warrior --

--Settings--
Tries = 3 -- how many times may someone type the wrong password
Ban = true
--Settings

AuthDir = {}
Auth = {}
X = {}
Y = {}
Z = {}
Count = {}
PlayerGM = {}
PlayerMSG= {}
function Initialize( Plugin )

	PLUGIN = Plugin
	
	Plugin:SetName( "Login" )
	Plugin:SetVersion( 1 )
       
	PluginManager = cRoot:Get():GetPluginManager()
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_DISCONNECT)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_CHAT)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_TOSSING_ITEM)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_JOINED)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_LEFT_CLICK)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_RIGHT_CLICK)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_MOVING)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_LOGIN)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_EXECUTE_COMMAND)
	
	PluginManager:BindCommand("/changepass", 		"login.changepass", 	HandleChangePasswordCommand,		" - Change you password");
	PluginManager:BindCommand("/register",            "login.register",            HandleRegisterCommand,            " - Register your account");
	PluginManager:BindCommand("/login",            "login.login",            HandleLoginCommand,            " - Logs you into your account");
	PluginManager:BindCommand("/logout",			"login.logout", 		HandleLogoutCommand,			" - Logs you out your account");
	PluginManager:BindCommand("/removeacc", 		"login.removeacc", 		HandleRemoveAccountCommand, 	" - Removes a account");
	PluginDir = Plugin:GetLocalDirectory() .. "/"
	LOG( "Initialized " .. Plugin:GetName() .. " v" .. Plugin:GetVersion() )
	return true
end

function OnExecuteCommand(Player, CommandSplit)
	if (Player == nil) then
		return false;
	end
	if (Auth[Player:GetName()] == true) then
		return false;
	end
		AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "r" )
	if 	AuthDir[Player:GetName()] then
		AuthDir[Player:GetName()]:close()
		if (CommandSplit[1] ~= "/login") then 
			return true
		end
	else		
		if (CommandSplit[1] ~= "/register") then
			return true
		end
	end
end

function OnPlayerTossingItem(Player)
	if Auth[Player:GetName()] == false then
		Player:SendMessage(cChatColor.Rose .. "Please log in before tossing items")
		return true
	end
end

function OnLogin(Client, ProtocolVersion, Username)
	local loopPlayers = function( PlayerNew )
        if(PlayerNew:GetName() == Username) then
            PlayerNew:SendMessage( "Somebody just tried to login in under your name." )
            Client:Kick( "[Server] Already ingame." )
        end
    end
    local loopWorlds = function ( World )
        World:ForEachPlayer( loopPlayers )
    end
end

function OnDisconnect(Player)
	if Auth[Player:GetName()] == false then
		LOGWARN("Player " .. Player:GetName() .. " Logged out without logging in")
	end
end

function OnChat(Player)
	if Auth[Player:GetName()] == false then
		Player:SendMessage(cChatColor.Rose .. "Please log in before you start talking")
		return true
	end
end

function OnPlayerMoving(Player)
	World = Player:GetWorld()
	if Auth[Player:GetName()] == false then
		PlayerMSG[Player:GetName()] = PlayerMSG[Player:GetName()] + 1
		if PlayerMSG[Player:GetName()] == 60 then
			if AuthDir[Player:GetName()] then
				Player:SendMessage(cChatColor.Rose .. "Please log in using /login (password)")
				PlayerMSG[Player:GetName()] = 1
			else
				Player:SendMessage(cChatColor.Rose .. "Please register using /register (password)")
				PlayerMSG[Player:GetName()] = 1
			end
		end
		Player:TeleportTo( World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ() )
	end
end

function OnPlayerLeftClick(Player)
	if Auth[Player:GetName()] == false then
		Player:SendMessage(cChatColor.Rose .. "Please log in before breaking blocks")
		return true
	end
end

function OnPlayerRightClick(Player)
	if Auth[Player:GetName()] == false then
		Player:SendMessage(cChatColor.Rose .. "Please log in before placing blocks")
		return true
	end
end

function OnPlayerJoined(Player)
	PlayerMSG[Player:GetName()] = 1
	Count[Player:GetName()] = Tries
	X[Player:GetName()] = Player:GetPosX()
	Y[Player:GetName()] = Player:GetPosY()
	Z[Player:GetName()] = Player:GetPosZ()
	Auth[Player:GetName()] = false
	AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "r" )
	if AuthDir[Player:GetName()] then
		AuthDir[Player:GetName()]:close()
		Player:SendMessage(cChatColor.Rose .. "Please use /login (Password) to login")
	else		
		Player:SendMessage(cChatColor.LightGreen .. "Please register using: /register (password)")
	end
end

function HandleChangePasswordCommand( Split, Player)
	if Auth[Player:GetName()] == true then
		if (Split[2] == nil) then
			Player:SendMessage(cChatColor.LightGreen .. "Usage: /changepass (oldpassword) (newpassword)")
		else
			PlayerPass = (io.open(PluginDir .. "Players/" .. Player:GetName(), "r"))
			Password = (io.lines(PluginDir .. "Players/" .. Player:GetName()))
			if Password() == md5(Split[2]) then
				os.remove(PluginDir .. "Players/" .. Player:GetName())
				AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "w" )
				AuthDir[Player:GetName()]:write(md5(Split[3]))
				AuthDir[Player:GetName()]:close()
				Player:SendMessage(cChatColor.LightGreen .. "Password changed to " .. Split[3])
			else
				Player:SendMessage(cChatColor.Rose .. "your old password is wrong. Usage: /changepass (oldpassword) (newpassword)")
			end
		end
	end
	return true
end
			
function HandleLogoutCommand( Split, Player )
	PlayerMSG[Player:GetName()] = -99999999999999999999999999
	X[Player:GetName()] = Player:GetPosX()
	Y[Player:GetName()] = Player:GetPosY()
	Z[Player:GetName()] = Player:GetPosZ()
	Count[Player:GetName()] = Tries
	Auth[Player:GetName()] = false
	Player:SendMessage(cChatColor.LightGreen .. "You are now logged out")
	Count[Player:GetName()] = Tries
	return true
end

function HandleLoginCommand( Split, Player)
	if Auth[Player:GetName()] == false then
		if (Split[2] == nil) then
		Player:SendMessage(cChatColor.LightGreen .. "Usage: /login (password)")
		else
			local PlayerPass = io.open(PluginDir .. "Players/" .. Player:GetName(), "r")
			if PlayerPass then
				local line = PlayerPass:read("*all")
				if line == md5(Split[2]) then
					Auth[Player:GetName()] = true
					Player:SendMessage(cChatColor.LightGreen .. "You are logged in")
					Player:LoadPermissionsFromDisk()
					Player:TeleportTo( X[Player:GetName()], Y[Player:GetName()], Z[Player:GetName()] )
				else
					Count[Player:GetName()] = Count[Player:GetName()] - 1
					Player:SendMessage(cChatColor.Rose .. "Wrong Password, You have " .. Count[Player:GetName()] .. " tries left")
				if Count[Player:GetName()] == 0 then
					Player:TeleportTo( X[Player:GetName()], Y[Player:GetName()], Z[Player:GetName()] )
					local ClientHandle = Player:GetClientHandle()
					ClientHandle:Kick( "You used a wrong password too many times" )
				end
			end
			PlayerPass:close()
		end					
	end		
	else
		Player:SendMessage(cChatColor.LightGreen .. "You are already logged in")
	end
	return true
end

function HandleRegisterCommand( Split, Player )
	if (Split[2] == nil) then
		Player:SendMessage(cChatColor.Rose .. "Usage: /register (password)")
	else
		AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "r" )
		PDIP = io.open(PluginDir .. "IP/" .. Player:GetName(), "w")
		if AuthDir[Player:GetName()] then
			Player:SendMessage(cChatColor.Rose .. "you already have registered")
		else
			Auth[Player:GetName()] = true
			AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "w" )
			AuthDir[Player:GetName()]:write(md5(Split[2]))
			AuthDir[Player:GetName()]:close()
			Player:SendMessage(cChatColor.Green .. "You have registered")
		end
	end
	return true
end


function HandleRemoveAccountCommand( Split, Player )
	if (Split[2] == nil) then
		Player:SendMessage(cChatColor.LightGreen .. "Usage: /removeacc (player)")
	else
		AuthDir[Split[2]] = io.open(PluginDir .. "Players/" .. Split[2], "r" )
		if AuthDir[Split[2]] then
			AuthDir[Split[2]]:close()
			os.remove(PluginDir .. "Players/" .. Split[2])
			Player:SendMessage(cChatColor.LightGreen .. "Account Removed")
		else
			Player:SendMessage(cChatColor.Rose .. "Acount does not exist")
		end
	end
	return true
end



function OnDisable()
    local loopPlayers = function( Player )
			local ClientHandle = Player:GetClientHandle()
			ClientHandle:Kick( "Server Reloaded" )
    end
    local loopWorlds = function ( World )
        World:ForEachPlayer( loopPlayers )
    end
    cRoot:Get():ForEachWorld( loopWorlds )
	LOG(PLUGIN:GetName() .." v".. PLUGIN:GetVersion() .." is shutting down")
end
