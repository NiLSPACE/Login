


local g_DataBuffer = {}
local g_Servers = {}





local LinkCallbacks = {
	OnConnected = function(a_TCPLink)
		print("DSFo; ")
		g_DataBuffer[a_TCPLink] = {data = "", headers = {}, headers_parsed = false}
	end,
	OnError = function(a_TCPLink, a_ErrorCode, a_ErrorMsg) end,
	OnReceivedData = function(a_TCPLink, a_Data)
		g_DataBuffer[a_TCPLink] = g_DataBuffer[a_TCPLink] or {data = "", headers = {}, headers_parsed = false}
		local buffer = g_DataBuffer[a_TCPLink]
		buffer.data = buffer.data .. a_Data
		
		local success, result = HandleRequest(buffer)
		if (not success) then
			return
		end
		
		a_TCPLink:Send(CreateResponse(result))
		a_TCPLink:Shutdown()
		g_DataBuffer[a_TCPLink] = nil
	end,
	OnRemoteClosed = function(a_TCPLink)
		-- Clear the buffer
		g_DataBuffer[a_TCPLink] = nil
	end,
}




local ListenCallbacks = {
	OnAccepted = function(a_TCPLink) end,
	OnError = function(a_ErrorCode, a_ErrorMsg) end,
	OnIncomingConnection = function(a_RemoteIP, a_RemotePort, a_LocalPort)
		return LinkCallbacks
	end
}



-- APICall to register a new user.
local function API_RegisterUser(a_Data)
	local uuid = GetUUIDFromPlayerName(a_Data.playername)
	local password = a_Data.password
	
	if (g_PassStorage:UUIDExists(uuid)) then
		return {result = 'failed', msg = 'The user is already registered'}
	end
	
	local success, msg = g_PassStorage:RegisterOrChangePassword(uuid, password)
	if (not success) then
		return {result = "failed", msg = msg}
	end
	return {result = 'success', msg = 'The user is registered'}
end




local g_APICalls = {
	RegisterUser = API_RegisterUser,
}




--- Splits a HTTP header up and saves it in a table as a dictionary
-- The key is always lowercase
local function ParseHeaders(a_Buffer)
	local headers = a_Buffer.data
	local Res = {}
	
	-- Go through each line of the header except for the first one.
	local SplittedHeaders = StringSplit(headers, "\n")
	for I = 2, #SplittedHeaders do
		local Header = SplittedHeaders[I]
		local HeaderInfo = StringSplitAndTrim(Header, ":")
		local Name = HeaderInfo[1]:lower()
		local Value = HeaderInfo[2]
		
		Res[Name] = Value
	end
	
	a_Buffer.headers = Res
end




function InitNetworkAPI(port)
	table.insert(g_Servers, cNetwork:Listen(port, ListenCallbacks))
end




function DisableNetworkAPI()
	for _, server in ipairs(g_Servers) do
		server:Close()
	end
end




function CreateResponse(a_Data)
	local serialized = cJson:Serialize(a_Data)
	local headers = {
		["Content-Length"] = serialized:len(),
		["Content-Type"] = "application/json"
	}
	
	local res = "HTTP/1.1 200 OK\r\n"
	for header, value in pairs(headers) do
		res = res .. header .. ": " .. value .. "\r\n"
	end
	res = res .. "\r\n" .. serialized
	return res
end





function HandleRequest(a_Buffer)
	if (not a_Buffer.headers_parsed and a_Buffer.data:match("\r\n\r\n")) then
		ParseHeaders(a_Buffer)
		a_Buffer.headers_parsed = true
	end
	
	if (not a_Buffer.headers_parsed) then
		return false
	end
	
	if (a_Buffer.headers['authorization'] ~= g_Config.NetworkAPI.Secret) then
		LOGWARNING("[Login] Attempt to call the API but the secret did not match")
		return false
	end
	
	local data = a_Buffer.data:match("\r\n\r\n(.*)")
	if (tonumber(a_Buffer.headers['content-length']) ~= data:len()) then
		return false
	end
	
	local json = cJson:Parse(data)
	local action = json.action
	if (not action) then
		LOGWARNING("[Login] Invalid API call: No action given");
		return false;
	end
	
	local actionFunc = g_APICalls[action]
	if (not actionFunc) then
		LOGWARNING(("[Login] Invalid API call: action '%s' does not exist"):format(action));
		return false;
	end
	return true, actionFunc(json)
end




