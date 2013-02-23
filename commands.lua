-- Author STR_Warrior --

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
		PlayerPass = (io.input(PluginDir .. "Players/" .. Player:GetName()):read())
		if (Split[2] == nil) then
			Player:SendMessage(cChatColor.LightGreen .. "Usage: /login (password)")
		else
			if PlayerPass then
				if PlayerPass == md5(Split[2]) then
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
			--PlayerPass:close
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


