--[[Created by STR_Warrior]]--

function HandleRegisterCommand(Split, Player)
	local PlayerName = Player:GetName()
	if IsAuthed[Player:GetUniqueID()] then
		Player:SendMessage(cChatColor.LightGreen .. "You are already logged in")
		return true
	end
	if (#Split ~= 3) or (Split[2] ~= Split[3]) then
		Player:SendMessage(cChatColor.Rose .. "Usage: /register [Password] [ConfirmationPassword]")
		return true
	end
	PassWords:AddPass(PlayerName, Split[2])
	Player:TeleportToCoords(PlayerPos[Player:GetUniqueID()].x, PlayerPos[Player:GetUniqueID()].y, PlayerPos[Player:GetUniqueID()].z)
	IsAuthed[Player:GetUniqueID()] = true
	Player:SendMessage(cChatColor.LightGreen .. "You have registered")
	return true
end

function HandleLoginCommand(Split, Player)
	local PlayerName = Player:GetName()
	if IsAuthed[Player:GetUniqueID()] then
		Player:SendMessage(cChatColor.LightGreen .. "You are already logged in")
		return true
	end
	if #Split ~= 2 then
		Player:SendMessage(cChatColor.Rose .. "Usage: /login [Password]")
		return true
	end
	local Succes, Password = PassWords:GetPassFromPlayer(PlayerName)
	if not Succes then
		Player:SendMessage(cChatColor.Rose .. "You are not registered")
		return true
	end
	if md5(Split[2]) ~= Password then
		Player:SendMessage(cChatColor.Rose .. "Wrong password!")
		return true
	end
	Login(Player)
	
	return true
end

function HandleChangePassCommand(Split, Player)
	local PlayerName = Player:GetName()
	if #Split ~= 3 then
		Player:SendMessage(cChatColor.Rose .. "Usage: /changepass [OldPassword] [NewPassword]")
		return true
	end
	local Succes, Password = PassWords:GetPassFromPlayer(PlayerName)
	if not Succes then
		Player:SendMessage(cChatColor.Rose .. "You are not registered. What happened here?")
		return true
	end
	if md5(Split[2]) == Password then
		PassWords:ChangePass(PlayerName, Split[3])
		Player:SendMessage(cChatColor.LightGreen .. "You changed your password")
	else
		Player:SendMessage(cChatColor.Rose .. "You entered the wrong password")
	end
	return true
end

function HandleLogoutCommand(Split, Player)
	Logout(Player)
	return true
end

function HandleRemoveAccCommand(Split, Player)
	if #Split ~= 2 then
		Player:SendMessage(cChatColor.Rose .. "Usage: /removeacc [TargetPlayer]")
		return true
	end
	if PassWords:RemovePlayer(Split[2]) then
		Player:SendMessage(cChatColor.LightGreen .. "Account " .. Split[2] .. " was removed")
		return true
	end
	Player:SendMessage(cChatColor.Rose .. "Account " .. Split[2] .. " does not exist")
	return true
end

function HandleConsoleRemoveAccCommand(Split)
	if #Split ~= 2 then
		LOG("Usage: removeacc [TargetPlayer]")
		return true
	end
	if PassWords:RemovePlayer(Split[2]) then
		LOG("Account " .. Split[2] .. " was removed")
		return true
	end
	LOG("Account " .. Split[2] .. " does not exist")
	return true
end