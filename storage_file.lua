



cFileStorage = {}





function cFileStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cFileStorage)
	self.__index = self
	
	Obj.m_Passwords = {}
	Obj.m_Path      = cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/passwords.dat"
	
	local File = io.open(Obj.m_Path, "rb")
	if (not File) then
		File = io.open(Obj.m_Path, "w"):close()
	else
		local Content = File:read("*all")
		Content = cStringCompression.InflateString(Content)
		for line in Content:gmatch('[^\r\n]+') do
			local Split = StringSplit(line, "=")
			Obj.m_Passwords[Split[1]] = Split[2]
		end
		File:close()
	end
	
	return Obj
end





function cFileStorage:GetPasswordFromUUID(a_UUID)
	return self.m_Passwords[a_UUID] or false
end





function cFileStorage:RegisterOrChangePassword(a_UUID, a_NewPassword)
	self.m_Passwords[a_UUID] = cCryptoHash.md5HexString(a_NewPassword)
	return true
end





function cFileStorage:UUIDExists(a_UUID)
	return self.m_Passwords[a_UUID] ~= nil
end





function cFileStorage:DeleteUUID(a_UUID)
	self.m_Passwords[a_UUID] = nil
	return true
end





function cFileStorage:Disable()
	local str = ''
	for UUID, Password in pairs(self.m_Passwords) do
		str = str .. UUID .. "=" .. Password .. "\n"
	end
	
	local File = io.open(self.m_Path, "wb")
	File:write(cStringCompression.CompressStringZLIB(str, g_Config.CompressionLevel))
	File:close()
end





setmetatable(cFileStorage, cFileStorage)
cFileStorage.__index = cFileStorage




