--[[Created by STR_Warrior]]--

function OnPlayerDestroyed(Player)
	if Player == nil then
		return 
	end
	local PlayerName = Player:GetName()
	if not IsAuthed[PlayerName] then
		LOGWARNING("Player " .. PlayerName .. " Logged out while not being logged in")
	    Player:MoveTo(Vector3d(PlayerPos[PlayerName].x, PlayerPos[PlayerName].y, PlayerPos[PlayerName].z))
	end
	IsAuthed[PlayerName] = false
end

function OnHandshake(Client, UserName)
	if cRoot:Get():FindAndDoWithPlayer(UserName, function(OtherPlayer)
		if OtherPlayer ~= nil and UserName == OtherPlayer:GetName() then
			return true
		end
		return false
	end) then
		Client:Kick("There is somebody else online with the same name")
	end
end

function OnPlayerJoined(Player)
	
  if Player == nil then
		return 
	end
	
		local PlayerName = Player:GetName()
		IsAuthed[PlayerName] = false

end

function OnPlayerSpawned(Player)
	
		if Player == nil then
        return 
    end
    
	  local PlayerName = Player:GetName()
	  if not IsAuthed[PlayerName] then
		
			local World = Player:GetWorld()
	    
			PlayerPos[PlayerName] = Vector3d(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ())
	
			if PassWords:PlayerExists(PlayerName) then
			   Player:SendMessage(cChatColor.Rose .. "Please log in using /login [password]")
			else
		   	   Player:SendMessage(cChatColor.Rose .. "Please register using /register [password] [confirm_password]")
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
			AttackerPlayer:SendMessage(cChatColor.Rose .. "You have to log in before engaging in combat")
			return true
		end
	end
end

function OnRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	if Player == nil then
		return true
	end
	local PlayerName = Player:GetName()
	if BlockX == -1 and BlockY == 255 and BlockZ == -1 then
		if not IsAuthed[PlayerName] then
			return true
		end
		return false
	end
	if not IsAuthed[PlayerName] then
		Player:SendMessage(cChatColor.Rose .. "Log in first.")
		return true
	end
end

function OnLeftClick(Player, BlockX, BlockY, BlockZ, BlockFace, Status)
	if Player == nil then
		return true
	end
	if Status == 1 then
		return false
	end
	if not IsAuthed[Player:GetName()] then
		Player:SendMessage(cChatColor.Rose .. "Log in first.")
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
		Player:SendMessage(cChatColor.Rose .. "You have to log in before using commands")
		return true
	end
end

function OnChat(Player, Message)
	if Player == nil then
		return true
	end
	local PlayerName = Player:GetName()
	if not IsAuthed[PlayerName] then
		Player:SendMessage(cChatColor.Rose .. "You have to log in before talking")
		return true
	end
end

function OnPlayerMoving(Player)
	if Player == nil then
		return true
	end
	if not IsAuthed[Player:GetName()] then
		local World = Player:GetWorld()
		Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	end
end
