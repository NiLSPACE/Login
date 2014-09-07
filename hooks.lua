--[[Created by STR_Warrior]]--

function OnDisconnect(Player)
	local PlayerName = Player:GetName()
	if not IsAuthed[PlayerName] then
		LOGWARNING("Player " .. PlayerName .. " Logged out while not being logged in")
	end
	IsAuthed[PlayerName] = false
end

function OnHandshake(Client, UserName)
	if cRoot:Get():FindAndDoWithPlayer(UserName, function(OtherPlayer)
		if UserName == OtherPlayer:GetName() then
			return true
		end
		return false
	end) then
		Client:Kick("There is somebody else online with the same name")
	end
end

function OnPlayerJoined(Player)

	local PlayerName = Player:GetName()
	IsAuthed[PlayerName] = false

end

function OnSpawned(Player)

    	local PlayerName = Player:GetName()
    	if not IsAuthed[PlayerName] then
	
		local World = Player:GetWorld()
    
		PlayerPos[PlayerName] = Vector3d(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ())

		if PassWords:PlayerExists(PlayerName) then
		   Player:SendMessage(cChatColor.LightGreen .. "Use /login to login")
		else
	   	   Player:SendMessage(cChatColor.Rose .. "Use /register to register")
		end
    
	        if World ~= nil then
		  Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
    		end
    
  	end
	
end

function OnTakeDamage(Receiver, TDI)
	if Receiver:IsPlayer() then
		if not IsAuthed[Receiver:GetName()] then
			return true
		end
	end
	if TDI.Attacker ~= nil and TDI.Attacker:IsPlayer() then
		local AttackerPlayer = tolua.cast(TDI.Attacker,"cPlayer")
		if not IsAuthed[AttackerPlayer:GetName()] then
			AttackerPlayer:SendMessage("Log in first")
			return true
		end
	end
end

function OnRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	local PlayerName = Player:GetName()
	if BlockX == -1 and BlockY == 255 and BlockZ == -1 then
		if not IsAuthed[PlayerName] then
			return true
		end
		return false
	end
	if not IsAuthed[PlayerName] then
		Player:SendMessage("Log in first")
		return true
	end
end

function OnLeftClick(Player, BlockX, BlockY, BlockZ, BlockFace, Status)
	if Status == 1 then
		return false
	end
	if not IsAuthed[Player:GetName()] then
		Player:SendMessage("Log in first")
		return true
	end 
end

function OnExecuteCommand(Player, CommandSplit)
	if Player == nil then
		return false
	end
	local PlayerName = Player:GetName()
	if not IsAuthed[PlayerName] then
		if CommandSplit[1] == "/login" or CommandSplit[1] == "/register" then
			return false
		end
		Player:SendMessage(cChatColor.Rose .. "Login first before using commands")
		return true
	end
end

function OnChat(Player, Message)
	local PlayerName = Player:GetName()
	if not IsAuthed[PlayerName] then
		Player:SendMessage(cChatColor.Rose .. "Login first before talking")
		return true
	end
end

function OnPlayerMoving(Player)
	if not IsAuthed[Player:GetName()] then
		local World = Player:GetWorld()
		Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	end
end

function OnTick(Time)
	Ticks = Ticks + 1 -- We don't want to check everyone every tick.
	if Ticks > 10 then
		cRoot:Get():ForEachPlayer(function(Player)
			if not IsAuthed[Player:GetName()] then
				local World = Player:GetWorld()
				Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
			end
		end)
		Ticks = 0
	end
end
