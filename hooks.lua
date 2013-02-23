-- Author STR_Warrior --

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
