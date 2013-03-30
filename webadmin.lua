function HandleRequest_Login( Request )
	local Content = "" 
	if( Request.PostParams["Disable"] ~= nil ) then
		if Disable == nil then
			Disable = true
			Content = Content .. [[<b style="color: green;">Nobody now needs to login</b>]]
		elseif Disable == false then
			Disable = true
			Content = Content .. [[<b style="color: green;">Nobody now needs to login</b>]]
		else
			Disable = false
			Content = Content .. [[<b style="color: green;">Login Plugin enabled</b>]]
		end
	elseif( Request.PostParams["tDisable"] ~= nil ) then
		if tDisable == nil then
			tDisable = true
			Content = Content .. [[<b style="color: green;">The next person joins in doesn't need to login</b>]]
		elseif tDisable == false then
			tDisable = true
			Content = Content .. [[<b style="color: green;">The next person who joins doesn't need to login</b>]]
		else
			tDisable = false
			Content = Content .. [[<b style="color: green;">Everyone needs to login again</b>]]
		end
	end
	
	Content = Content .. [[
	<form method="POST">]]
	Content = Content .. [[<table>
	<tr style="padding-top:5px;">
	<th colspan="2">Disable</th>
	<tr><td style="width: 30%;">Disable:</td>
	<td><input type="submit" value="     Disable     " name="Disable"> Disable the login plugin </td>
	<tr><td>Temporary disable:</td>
	<td><input type="submit" value="Temporary disable" name="tDisable"> Temporary disable the login plugin</td>
	</tr>
	</table>
	]]
	return Content
end