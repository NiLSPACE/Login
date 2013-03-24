-- Author STR_Warrior --

function HandleChangePasswordCommand( Split, Player)
	if Auth[Player:GetName()] == true then
		if (Split[2] == nil) then
			Player:SendMessage(cChatColor.LightGreen .. ChangePassword)
		else
			if Storage ~= "Ini" then
				PlayerPass = (io.open(PluginDir .. "Players/" .. Player:GetName(), "r"))
				Password = (io.lines(PluginDir .. "Players/" .. Player:GetName()))
				if Password() == md5(Split[2]) then
					os.remove(PluginDir .. "Players/" .. Player:GetName())
					AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "w" )
					AuthDir[Player:GetName()]:write(md5(Split[3]))
					AuthDir[Player:GetName()]:close()
					Player:SendMessage(cChatColor.LightGreen .. "Password changed to " .. Split[3])
				else
					Player:SendMessage(cChatColor.Rose .. ChangePasswordWrong)
				end
			else
				LOG(md5(Split[2]))
				LOG( PassIni:GetValue(Player:GetName(), "Password") )
				if PassIni:GetValue(Player:GetName(), "Password") == md5(Split[2]) then
					PassIni:DeleteKey(Player:GetName())
					PassIni:SetValue(Player:GetName(), "Password", md5(Split[3]))
					PassIni:WriteFile()
					Player:SendMessage(cChatColor.LightGreen .. "Password changed to " .. Split[3])
				else
					Player:SendMessage(cChatColor.Rose .. ChangePasswordWrong)
				end
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
	Player:SendMessage(cChatColor.LightGreen .. Logout)
	Count[Player:GetName()] = Tries
	return true
end

function HandleLoginCommand( Split, Player)
	if Auth[Player:GetName()] == false then
		if (Split[2] == nil) then
			Player:SendMessage(cChatColor.LightGreen .. Login)
		else
			if Storage ~= "Ini" then
				local PlayerPass = io.open(PluginDir .. "Players/" .. Player:GetName(), "r")
				if PlayerPass then
					local line = PlayerPass:read("*all")
					if line == md5(Split[2]) then
						Auth[Player:GetName()] = true
						Player:SendMessage(cChatColor.LightGreen .. LoggedIn)
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
				end
				PlayerPass:close()
			else
				if PassIni:GetValue(Player:GetName(), "Password") == md5(Split[2]) then
					Auth[Player:GetName()] = true
					Player:SendMessage(cChatColor.LightGreen .. LoggedIn)
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
			end
		end             
	else
		Player:SendMessage(cChatColor.LightGreen .. AlreadyLoggedIn)
	end
	return true
end


function HandleRegisterCommand( Split, Player )
	if (Split[2] == nil) then
		Player:SendMessage(cChatColor.Rose .. Register)
	else
		if Storage ~= "Ini" then
			AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "r" )
			if AuthDir[Player:GetName()] then
				Player:SendMessage(cChatColor.Rose .. AlreadyRegistered)
			else
				Auth[Player:GetName()] = true
				AuthDir[Player:GetName()] = io.open(PluginDir .. "Players/" .. Player:GetName(), "w" )
				AuthDir[Player:GetName()]:write(md5(Split[2]))
				AuthDir[Player:GetName()]:close()
				Player:SendMessage(cChatColor.Green .. Registered)
			end
		else
			if PassIni:FindKey(Player:GetName()) ~= -1 then
				Player:SendMessage(cChatColor.Rose .. AlreadyRegistered)
			else
				PassIni:SetValue(Player:GetName(), "Password", md5(Split[2]))
				PassIni:WriteFile()
				Auth[Player:GetName()] = true
				Player:SendMessage(cChatColor.Green .. Registered)
			end
		end
	end
	return true
end


function HandleRemoveAccountCommand( Split, Player )
	if (Split[2] == nil) then
		Player:SendMessage(cChatColor.LightGreen .. RemoveAcc)
	else
		if Storage ~= "Ini" then
			AuthDir[Split[2]] = io.open(PluginDir .. "Players/" .. Split[2], "r" )
			if AuthDir[Split[2]] then
				AuthDir[Split[2]]:close()
				os.remove(PluginDir .. "Players/" .. Split[2])
				Player:SendMessage(cChatColor.LightGreen .. AccountRemoved)
			else
				Player:SendMessage(cChatColor.Rose .. DeleteNoAccount)
			end
		else
			if PassIni:FindKey(Split[2]) == -1 then
				Player:SendMessage(cChatColor.Rose .. DeleteNoAccount)
			else
				PassIni:DeleteKey(Split[2])
				Player:SendMessage(cChatColor.LightGreen .. AccountRemoved)
			end
		end
	end
	return true
	end


