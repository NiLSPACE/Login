--[[Created by STR_Warrior]]--

function OnPlayerDestroyed(Player)

	if Player == nil then
		return 
	end
	
	if not IsAuthed[Player:GetUniqueID()] then
		LOGWARNING("Player " .. Player:GetName() .. " Logged out while not being logged in")
		Player:MoveTo(Vector3d(PlayerPos[Player:GetUniqueID()].x, PlayerPos[Player:GetUniqueID()].y, PlayerPos[Player:GetUniqueID()].z))
	end

	IsAuthed[Player:GetUniqueID()] = nil
	
end

function OnHandshake(Client, UserName)
	if cRoot:Get():FindAndDoWithPlayer(UserName, function(OtherPlayer)
		if OtherPlayer ~= nil and UserName == OtherPlayer:GetName() then
			return true
		end
		return false
		
	end) then
	
		Client:Kick("There is somebody else online with the same name")
		return true
		
	end
	
	return false
end

function OnPlayerJoined(Player)
	
	if Player == nil then
		return 
	end
	
	IsAuthed[Player:GetUniqueID()] = false

end

function OnPlayerSpawned(Player)
	
	if Player == nil then
		return 
	end
    
	local PlayerName = Player:GetName()
	if not IsAuthed[Player:GetUniqueID()] then
		
		local World = Player:GetWorld()
	    
		PlayerPos[Player:GetUniqueID()] = Vector3d(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ())
	
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
		if not IsAuthed[Receiver:GetUniqueID()] then
			return true
		end
	end
	if TDI.Attacker ~= nil and TDI.Attacker:IsPlayer() then
		local AttackerPlayer = tolua.cast(TDI.Attacker,"cPlayer")
		if not IsAuthed[AttackerPlayer:GetUniqueID()] then
			AttackerPlayer:SendMessage(cChatColor.Rose .. "You have to log in before engaging in combat")
			return true
		end
	end
end

function OnRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	if Player == nil then
		return true
	end
	if BlockX == -1 and BlockY == 255 and BlockZ == -1 then
		if not IsAuthed[Player:GetUniqueID()] then
			return true
		end
		return false
	end
	if not IsAuthed[Player:GetUniqueID()] then
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
	if not IsAuthed[Player:GetUniqueID()] then
		Player:SendMessage(cChatColor.Rose .. "Log in first.")
		return true
	end 
end

function OnExecuteCommand(Player, CommandSplit)
	if Player == nil then
		return false
	end
	if not IsAuthed[Player:GetUniqueID()] then
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
	if not IsAuthed[Player:GetUniqueID()] then
		Player:SendMessage(cChatColor.Rose .. "You have to log in before talking")
		return true
	end
end

function OnPlayerMoving(Player)
	if Player == nil then
		return true
	end
	if not IsAuthed[Player:GetUniqueID()] then
		local World = Player:GetWorld()
		Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	end
end
