function HandleConsoleCommand( Split )
	if Split[2] == nil then
		HandleConsoleHelp(Split)
	elseif Split[2] == "disable" then
		if Disable == nil then
			Disable = true
			LOG("Nobody now needs to login")
		elseif Disable == false then
			Disable = true
			LOG("Nobody now needs to login")
		else
			Disable = false
			LOG("Login Plugin enabled")
		end
	elseif Split[2] == "tdisable" then
		if tDisable == nil then
			tDisable = true
			LOG("The next person who logs in doesn't need to login")
		elseif tDisable == false then
			tDisable = true
			LOG("The next person who logs in doesn't need to login")
		else
			tDisable = false
			LOG("Everyone needs to login again")
		end
	elseif Split[2] == "help" or "?" then
		HandleConsoleHelp(Split)
	end
	return true
end
	
function HandleConsoleHelp(Split)
	LOG("--------Help--------")
	LOG( "/" .. Split[1] .. " disable")
	LOG( "/" .. Split[1] .. " tdisable")
	LOG( "/" .. Split[1] .. " help")
end