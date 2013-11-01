function HandleRequest_ManageAccs(Request)
	local Content = ""
	if WebAdminPasswordOn then
		if Request.PostParams["WebAdminPass"] ~= nil then
			if Request.PostParams["WebAdminPass"] == WebAdminPassword then
				IsAuthedWebAdmin[Request.Username] = true
			end
		end
		if IsAuthedWebAdmin[Request.Username] then
			Content = Content .. GetMainPage(Request)
		else
			Content = Content .. '<b style="color: red;">You have to login</b>'
			Content = Content .. '<form method="POST"><td><input type="password" name="WebAdminPass">'
			Content = Content .. '<td><input type="submit" value="Login" name="AddAcc"></form>'
		end
	else
		Content = Content .. GetMainPage(Request)
	end
	return Content
end

function GetMainPage(Request)
	local Content = [[
	<table>
		<tr>
			<td><a href="?tab=Manage_Accounts">Manage Accounts</a></td>
			<td><a href="?tab=Show_Online_Players">Show Online Players</a></td>
		</tr>
	</table>
	<br />
	]]
	if (Request.Params["tab"] == "Manage_Accounts") then
		Content = Content .. WebAdmin_ManageLoginAccounts(Request)
	elseif (Request.Params["tab"] == "Show_Online_Players")then
		Content = Content .. WebAdmin_Show_Online(Request)
	elseif (Request.Params["tab"] == nil) then
		Content = Content .. "Please choose one of the tabs above"
	else
		Content = Content .. "<h1>Page not found</h1>"
	end
	return Content
end

function WebAdmin_Show_Online(Request)
	local Content = ""
	if Request.PostParams["Log_Out"] ~= nil and Request.PostParams["PlayerName"] ~= nil then
		local Callback = function(Player)
			Logout(Player)
		end
		IsAuthed[Request.PostParams["PlayerName"]] = false -- We have to logout the player otherwise the webadmin is outdated.
		FindAndDoWithPlayer(Request.PostParams["PlayerName"], Callback)
		Content = Content .. [[<b style="color: green;">You logged player ]] .. Request.PostParams["PlayerName"] .. [[ out.</b>]]
	end

	if Request.PostParams["Log_In"] ~= nil and Request.PostParams["PlayerName"] ~= nil then
		local Callback = function(Player)
			Login(Player)
		end
		IsAuthed[Request.PostParams["PlayerName"]] = true -- We have to login the player otherwise the webadmin is outdated.
		FindAndDoWithPlayer(Request.PostParams["PlayerName"], Callback)
		Content = Content .. [[<b style="color: green;">You logged player ]] .. Request.PostParams["PlayerName"] .. [[ in.</b>]]
	end 
	Content = Content .. [[
	<form method='POST'>
		<table>
			<th colspan="3">There are ]] .. cRoot:Get():GetServer():GetNumPlayers() .. [[ Players online</th>
			<tr>
				<td>Player</td>
				<td>Logged in</td>
				<td>Log out/in</td>
			</tr>
	]]
	cRoot:Get():ForEachPlayer(function(Player)
		local PlayerName = Player:GetName()
		if IsAuthed[PlayerName] then
			Content = Content .. [[
			<tr>
				<td>]] .. PlayerName .. [[</td>
				<td><b style="color: green;">Yes</b></td>
				<td><input type="hidden" value="]] .. PlayerName .. [[" name="PlayerName"><input type='submit' name='Log_Out' value='Log out'></td>
			</tr>]]
		else
			Content = Content .. [[
			<tr>
				<td>]] .. PlayerName .. [[</td>
				<td><b style="color: red;">No</b></td>
				<td><input type="hidden" value="]] .. PlayerName .. [[" name="PlayerName"><input type='submit' name='Log_In' value='Log in'></td>
			</tr>]]
		end
	end)
	Content = Content .. [[</table></form>]]
	return Content
end
		
function WebAdmin_ManageLoginAccounts(Request)
	local Content = ""
	local Search = {}
	local Table = PassWords:ReturnTable()

	if Request.PostParams["Search"] ~= nil then
		if Request.PostParams["SearchKey"] == "" and Request.PostParams["SearchKey"] == nil then
			Content = Content .. '<b style="color: green;">Please give a player name to search for</b>'
		else
			for I, k in pairs(Table) do
				if string.find(string.upper(I), string.upper(Request.PostParams["SearchKey"])) then
					table.insert(Search, [[
					<tr>
						<td>]] .. I .. [[</td>
						<td><form method='POST'><input type='hidden' name='PlayerName' value=']] .. I .. [['><input type='submit' name='RemoveAcc' value='Delete'></form></td>
					</tr>]])
				end
			end
		end
	end

	if Request.PostParams["RemoveAcc"] ~= nil and Request.PostParams["PlayerName"] ~= nil then
		PassWords:RemovePlayer(Request.PostParams["PlayerName"])
		Content = Content .. '<b style="color: green;">Removed account ' .. Request.PostParams["PlayerName"] .. "</b><br />"
	end
	if Request.PostParams["AddAcc"] ~= nil then
		if Request.PostParams["AddAcc_Player"] ~= "" then
			if Request.PostParams["AddAcc_Password"] ~= "" then
				if PassWords:AddPass(Request.PostParams["AddAcc_Player"], Request.PostParams["AddAcc_Password"]) then
					Content = Content .. '<b style="color: green;">Added player ' .. Request.PostParams["AddAcc_Player"] .. "</b>"
				else
					Content = Content .. '<b style="color: red;">The player already exists</b>'
				end
			else
				Content = Content .. '<b style="color: red;">You forgot to add a password</b>'
			end
		else
			Content = Content .. '<b style="color: red;">You forgot to add a playername</b>'
		end
	end
	Content = Content .. [[
		<form method='POST' name='SEARCH'>
			<table>
				<th colspan="2">Search</th>
				<tr>
					<td>Player</td>
					<td>Search</td>
				</tr>
				<tr>
					<td><input type='text' name='SearchKey'></td>
					<td><input type='submit' value='Search' name='Search'></td>
				</tr>
			</form>]]
		for I, k in pairs(Search) do
			Content = Content .. k
		end
		Content = Content .. [[</table>
		<br />
		<form method='POST' name='ADDACC'>
			<table>
				<th colspan="3">Add account</th>
				<tr>
					<td>PlayerName</td>
					<td>Password</td>
					<td>Submit</td>
				</tr><tr>
					<td><input type="text" name="AddAcc_Player"></td>
					<td><input type="password" name="AddAcc_Password"></td>
					<td><input type="submit" value="Add Player" name="AddAcc"></td>
				</tr>
			</table>
		</form>
		<br />
			<table>
				<th colspan="2">Remove account</th>
		]]
	for I, k in pairs(Table) do
		Content = Content .. [[
				<tr>
					<td>]] .. I .. [[</td>
					<td><form method='POST'> <input type='hidden' name='PlayerName' value=']] .. I .. [['><input type='submit' name='RemoveAcc' value='Delete'></form></td>
				</tr>]]
	end
	Content = Content .. [[</table>]]
	return Content
end

function FindAndDoWithPlayer(PlayerName, Callback)
	cRoot:Get():ForEachWorld(function(World)
		World:QueueTask(function(a_World)
			a_World:DoWithPlayer(PlayerName, function(Player)
				Callback(Player)
			end)
		end)
	end)
end
	